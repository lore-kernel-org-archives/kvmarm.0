Return-Path: <SRS0=cLXx=CZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF87CC433E2
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 15:45:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ECDB8204FD
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 15:45:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ayYOZwu0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECDB8204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14EB44B4C4;
	Wed, 16 Sep 2020 11:45:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rjtn9wnTc0rN; Wed, 16 Sep 2020 11:45:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8FE54B331;
	Wed, 16 Sep 2020 11:45:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83C9C4B4C8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 11:45:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x+Aigaz3oHV3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Sep 2020 11:45:36 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71E7D4B4BC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 11:45:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1600271136;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=v0Rllmkg6HO+EgoA8KDDJB8xLQsK0SSrwqJJXtiPqOE=;
 b=ayYOZwu0O5TICquBohLuy3B71awiICJw9a+BEc0mnFlQXPTUCFr8MSpVE1XuAG8TLOs4Qt
 9pJ6H0jJg8CTowFlyWvXyDhOjZh3Na7PSs0np/HLJAenCbQmLtkhm1Xj7aBPQe6a54Yax1
 0AZJFpv2fhKpeJ3kOre5QY+7xVXkb9Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-QwbzSAHNPgKvaDfgbTlZTw-1; Wed, 16 Sep 2020 11:45:34 -0400
X-MC-Unique: QwbzSAHNPgKvaDfgbTlZTw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26D891084D75;
 Wed, 16 Sep 2020 15:45:33 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.162])
 by smtp.corp.redhat.com (Postfix) with ESMTP id CF35B4D;
 Wed, 16 Sep 2020 15:45:31 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH] arm64: paravirt: Initialize steal time when cpu is online
Date: Wed, 16 Sep 2020 17:45:30 +0200
Message-Id: <20200916154530.40809-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: redhat.com
Cc: maz@kernel.org, steven.price@arm.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Steal time initialization requires mapping a memory region which
invokes a memory allocation. Doing this at CPU starting time results
in the following trace when CONFIG_DEBUG_ATOMIC_SLEEP is enabled:

BUG: sleeping function called from invalid context at mm/slab.h:498
in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 0, name: swapper/1
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.9.0-rc5+ #1
Call trace:
 dump_backtrace+0x0/0x208
 show_stack+0x1c/0x28
 dump_stack+0xc4/0x11c
 ___might_sleep+0xf8/0x130
 __might_sleep+0x58/0x90
 slab_pre_alloc_hook.constprop.101+0xd0/0x118
 kmem_cache_alloc_node_trace+0x84/0x270
 __get_vm_area_node+0x88/0x210
 get_vm_area_caller+0x38/0x40
 __ioremap_caller+0x70/0xf8
 ioremap_cache+0x78/0xb0
 memremap+0x9c/0x1a8
 init_stolen_time_cpu+0x54/0xf0
 cpuhp_invoke_callback+0xa8/0x720
 notify_cpu_starting+0xc8/0xd8
 secondary_start_kernel+0x114/0x180
CPU1: Booted secondary processor 0x0000000001 [0x431f0a11]

However we don't need to initialize steal time at CPU starting time.
We can simply wait until CPU online time, just sacrificing a bit of
accuracy by returning zero for steal time until we know better.

While at it, add __init to the functions that are only called by
pv_time_init() which is __init.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kernel/paravirt.c | 26 +++++++++++++++-----------
 include/linux/cpuhotplug.h   |  1 -
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
index 295d66490584..c07d7a034941 100644
--- a/arch/arm64/kernel/paravirt.c
+++ b/arch/arm64/kernel/paravirt.c
@@ -50,16 +50,19 @@ static u64 pv_steal_clock(int cpu)
 	struct pv_time_stolen_time_region *reg;
 
 	reg = per_cpu_ptr(&stolen_time_region, cpu);
-	if (!reg->kaddr) {
-		pr_warn_once("stolen time enabled but not configured for cpu %d\n",
-			     cpu);
+
+	/*
+	 * paravirt_steal_clock() may be called before the CPU
+	 * online notification callback runs. Until the callback
+	 * has run we just return zero.
+	 */
+	if (!reg->kaddr)
 		return 0;
-	}
 
 	return le64_to_cpu(READ_ONCE(reg->kaddr->stolen_time));
 }
 
-static int stolen_time_dying_cpu(unsigned int cpu)
+static int stolen_time_cpu_down_prepare(unsigned int cpu)
 {
 	struct pv_time_stolen_time_region *reg;
 
@@ -73,7 +76,7 @@ static int stolen_time_dying_cpu(unsigned int cpu)
 	return 0;
 }
 
-static int init_stolen_time_cpu(unsigned int cpu)
+static int stolen_time_cpu_online(unsigned int cpu)
 {
 	struct pv_time_stolen_time_region *reg;
 	struct arm_smccc_res res;
@@ -103,19 +106,20 @@ static int init_stolen_time_cpu(unsigned int cpu)
 	return 0;
 }
 
-static int pv_time_init_stolen_time(void)
+static int __init pv_time_init_stolen_time(void)
 {
 	int ret;
 
-	ret = cpuhp_setup_state(CPUHP_AP_ARM_KVMPV_STARTING,
-				"hypervisor/arm/pvtime:starting",
-				init_stolen_time_cpu, stolen_time_dying_cpu);
+	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN,
+				"hypervisor/arm/pvtime:online",
+				stolen_time_cpu_online,
+				stolen_time_cpu_down_prepare);
 	if (ret < 0)
 		return ret;
 	return 0;
 }
 
-static bool has_pv_steal_clock(void)
+static bool __init has_pv_steal_clock(void)
 {
 	struct arm_smccc_res res;
 
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 3215023d4852..bf9181cef444 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -142,7 +142,6 @@ enum cpuhp_state {
 	/* Must be the last timer callback */
 	CPUHP_AP_DUMMY_TIMER_STARTING,
 	CPUHP_AP_ARM_XEN_STARTING,
-	CPUHP_AP_ARM_KVMPV_STARTING,
 	CPUHP_AP_ARM_CORESIGHT_STARTING,
 	CPUHP_AP_ARM_CORESIGHT_CTI_STARTING,
 	CPUHP_AP_ARM64_ISNDEP_STARTING,
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
