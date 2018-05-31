From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 00/17] arm64 SSBD (aka Spectre-v4) mitigation
Date: Thu, 31 May 2018 17:55:27 +0100
Message-ID: <b6111f31-b128-94f2-ae6b-03a906358c0b@arm.com>
References: <20180529121121.24927-1-marc.zyngier@arm.com>
 <20180531164133.6z6py7nl55ty473e@armageddon.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180531164133.6z6py7nl55ty473e@armageddon.cambridge.arm.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Randy Dunlap <rdunlap@infradead.org>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Julien Grall <julien.grall@arm.com>, Andy Lutomirski <luto@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Catalin,

On 31/05/18 17:41, Catalin Marinas wrote:
> On Tue, May 29, 2018 at 01:11:04PM +0100, Marc Zyngier wrote:
>> Marc Zyngier (17):
>>   arm/arm64: smccc: Add SMCCC-specific return codes
>>   arm64: Call ARCH_WORKAROUND_2 on transitions between EL0 and EL1
>>   arm64: Add per-cpu infrastructure to call ARCH_WORKAROUND_2
>>   arm64: Add ARCH_WORKAROUND_2 probing
>>   arm64: Add 'ssbd' command-line option
>>   arm64: ssbd: Add global mitigation state accessor
>>   arm64: ssbd: Skip apply_ssbd if not using dynamic mitigation
>>   arm64: ssbd: Restore mitigation status on CPU resume
>>   arm64: ssbd: Introduce thread flag to control userspace mitigation
>>   arm64: ssbd: Add prctl interface for per-thread mitigation
>>   arm64: KVM: Add HYP per-cpu accessors
>>   arm64: KVM: Add ARCH_WORKAROUND_2 support for guests
>>   arm64: KVM: Handle guest's ARCH_WORKAROUND_2 requests
>>   arm64: KVM: Add ARCH_WORKAROUND_2 discovery through
>>     ARCH_FEATURES_FUNC_ID
> 
> I queued the 14 patches above for 4.18.

I just realized that your for-next/core branch is based on
4.17-rc4, which means arch/arm64/kernel/ssbd.c won't compile
(it relies on some of the symbols introduced with the x86
stuff in 4.17-rc7.

You can work around it by adding the following hack:

>From 8a0dbe9fb468c03b3913d17af9dce7358f899ee3 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <marc.zyngier@arm.com>
Date: Thu, 31 May 2018 17:54:11 +0100
Subject: [PATCH] fixup! arm64: ssbd: Add prctl interface for per-thread
 mitigation

---
 arch/arm64/kernel/ssbd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kernel/ssbd.c b/arch/arm64/kernel/ssbd.c
index 07b12c034ec2..3432e5ef9f41 100644
--- a/arch/arm64/kernel/ssbd.c
+++ b/arch/arm64/kernel/ssbd.c
@@ -11,7 +11,9 @@
 
 /*
  * prctl interface for SSBD
+ * FIXME: Drop the below ifdefery once merged in 4.18.
  */
+#ifdef PR_SPEC_STORE_BYPASS
 static int ssbd_prctl_set(struct task_struct *task, unsigned long ctrl)
 {
 	int state = arm64_get_ssbd_state();
@@ -105,3 +107,4 @@ int arch_prctl_spec_ctrl_get(struct task_struct *task, unsigned long which)
 		return -ENODEV;
 	}
 }
+#endif	/* PR_SPEC_STORE_BYPASS */
-- 
2.17.1


Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
