Received: from out-44.mta0.migadu.com (out-44.mta0.migadu.com [91.218.175.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E438737B71
	for <kvmarm@lists.linux.dev>; Tue,  6 Jun 2023 14:10:49 +0000 (UTC)
Date: Tue, 6 Jun 2023 14:10:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686060647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bf9SkeMiKUCTUvw2rUikdfaK7oF+Pe8KyV0t9zy0wqQ=;
	b=Zmr3KMCUPa700eNEa13HLX2vi61amnA5brCZCT1yhpa1zagXmOIu4e5/OW7e2HE0FJuW1b
	2B34VDEyvPcGhg5s2FM3QljymvT35in0XQmTGVZ/YzYUythOwJars0cF0KeCR7HHTtxxPe
	AAUQY1WJqukW95UnStDL2kgVXLILwrI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sebastian Ott <sebott@redhat.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix smp_processor_id() call in preemptible
 context
Message-ID: <ZH8+ZG7DOX9TYcIY@linux.dev>
References: <2f16f83e-ed60-fcb7-7f3d-0fa216c41cb9@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f16f83e-ed60-fcb7-7f3d-0fa216c41cb9@redhat.com>
X-Migadu-Flow: FLOW_OUT

Hi Sebastian,

On Tue, Jun 06, 2023 at 12:37:30PM +0200, Sebastian Ott wrote:
> Commit 1c913a1c35aa ("KVM: arm64: Iterate arm_pmus list to probe for
> default PMU") introduced a smp_processor_id() call in preemtible context:
> 
> [70506.110187] BUG: using smp_processor_id() in preemptible [00000000] code: qemu-system-aar/3078242
> [70506.119077] caller is debug_smp_processor_id+0x20/0x30
> [70506.124229] CPU: 129 PID: 3078242 Comm: qemu-system-aar Tainted: G        W          6.4.0-rc5 #25
> [70506.133176] Hardware name: GIGABYTE R181-T92-00/MT91-FS4-00, BIOS F34 08/13/2020
> [70506.140559] Call trace:
> [70506.142993]  dump_backtrace+0xa4/0x130
> [70506.146737]  show_stack+0x20/0x38
> [70506.150040]  dump_stack_lvl+0x48/0x60
> [70506.153704]  dump_stack+0x18/0x28
> [70506.157007]  check_preemption_disabled+0xe4/0x108
> [70506.161701]  debug_smp_processor_id+0x20/0x30
> [70506.166046]  kvm_arm_pmu_v3_set_attr+0x460/0x628
> [70506.170662]  kvm_arm_vcpu_arch_set_attr+0x88/0xd8
> [70506.175363]  kvm_arch_vcpu_ioctl+0x258/0x4a8
> [70506.179632]  kvm_vcpu_ioctl+0x32c/0x6b8
> [70506.183465]  __arm64_sys_ioctl+0xb4/0x100
> [70506.187467]  invoke_syscall+0x78/0x108
> [70506.191205]  el0_svc_common.constprop.0+0x4c/0x100
> [70506.195984]  do_el0_svc+0x34/0x50
> [70506.199287]  el0_svc+0x34/0x108
> [70506.202416]  el0t_64_sync_handler+0xf4/0x120
> [70506.206674]  el0t_64_sync+0x194/0x198
> 
> Just disable preemption for this section.

The call from a preemptible context is intentional, so this really
should just be raw_smp_processor_id(). Do you mind if we fix it with the
following?

From 2f4680ee6a5aea5c3cf826c84b86172b0b2c1a67 Mon Sep 17 00:00:00 2001
From: Oliver Upton <oliver.upton@linux.dev>
Date: Tue, 6 Jun 2023 06:44:54 -0700
Subject: [PATCH] KVM: arm64: Use raw_smp_processor_id() in
 kvm_pmu_probe_armpmu()

Sebastian reports that commit 1c913a1c35aa ("KVM: arm64: Iterate
arm_pmus list to probe for default PMU") introduced the following splat
with CONFIG_DEBUG_PREEMPT enabled:

[70506.110187] BUG: using smp_processor_id() in preemptible [00000000] code: qemu-system-aar/3078242
[70506.119077] caller is debug_smp_processor_id+0x20/0x30
[70506.124229] CPU: 129 PID: 3078242 Comm: qemu-system-aar Tainted: G        W          6.4.0-rc5 #25
[70506.133176] Hardware name: GIGABYTE R181-T92-00/MT91-FS4-00, BIOS F34 08/13/2020
[70506.140559] Call trace:
[70506.142993]  dump_backtrace+0xa4/0x130
[70506.146737]  show_stack+0x20/0x38
[70506.150040]  dump_stack_lvl+0x48/0x60
[70506.153704]  dump_stack+0x18/0x28
[70506.157007]  check_preemption_disabled+0xe4/0x108
[70506.161701]  debug_smp_processor_id+0x20/0x30
[70506.166046]  kvm_arm_pmu_v3_set_attr+0x460/0x628
[70506.170662]  kvm_arm_vcpu_arch_set_attr+0x88/0xd8
[70506.175363]  kvm_arch_vcpu_ioctl+0x258/0x4a8
[70506.179632]  kvm_vcpu_ioctl+0x32c/0x6b8
[70506.183465]  __arm64_sys_ioctl+0xb4/0x100
[70506.187467]  invoke_syscall+0x78/0x108
[70506.191205]  el0_svc_common.constprop.0+0x4c/0x100
[70506.195984]  do_el0_svc+0x34/0x50
[70506.199287]  el0_svc+0x34/0x108
[70506.202416]  el0t_64_sync_handler+0xf4/0x120
[70506.206674]  el0t_64_sync+0x194/0x198

Nonetheless, there's no functional requirement for disabling preemption,
as the cpu # is only used to walk the arm_pmus list. Fix it by using
raw_smp_processor_id() instead.

Fixes: 1c913a1c35aa ("KVM: arm64: Iterate arm_pmus list to probe for default PMU")
Reported-by: Sebastian Ott <sebott@redhat.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 491ca7eb2a4c..933a6331168b 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -700,7 +700,7 @@ static struct arm_pmu *kvm_pmu_probe_armpmu(void)
 
 	mutex_lock(&arm_pmus_lock);
 
-	cpu = smp_processor_id();
+	cpu = raw_smp_processor_id();
 	list_for_each_entry(entry, &arm_pmus, entry) {
 		tmp = entry->arm_pmu;
 

base-commit: 9561de3a55bed6bdd44a12820ba81ec416e705a7
-- 
2.41.0.rc0.172.g3f132b7071-goog

