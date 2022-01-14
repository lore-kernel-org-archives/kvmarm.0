Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8850C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 14 Jan 2022 14:08:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C97249F1B;
	Fri, 14 Jan 2022 09:08:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e60Soloob+xB; Fri, 14 Jan 2022 09:08:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04E9549E3F;
	Fri, 14 Jan 2022 09:08:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B67749EB3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Jan 2022 09:08:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xi5cMTmJK-Qr for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Jan 2022 09:08:07 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A7B4549E3F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Jan 2022 09:08:07 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id A1701B825F8;
 Fri, 14 Jan 2022 14:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429ADC36AF2;
 Fri, 14 Jan 2022 14:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1642169285;
 bh=o+84v8AARuSDTfw6kHuIEO2OrH3GI/MMeSuFgurdj1A=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Qc6SmWkoKVcx8o0bOy9uAYWeEjW8ievv8uYEERxjKrKR0HGm7XGubAp1wxqE33I6u
 yc9kXHN8mylAu+G42Y6ux3Hgk47kpmFzgXawWbB5TsYlN6rtdPNwI8NCNGWla1fy1m
 vMObs3vivLwAegCR9BCgu4LmOE6cLh3zxQa57bfn2bxUOYBETZaKszWJQeydw/pPR0
 AwDpBCRv1WyJhEIhaawvcdp5qW2fh4lT2qdCFUJvRutjxH2nvgV36pLkCZ5WjQp+Zb
 LQKwCxKEfZmMbnHISS/W1swH4IyEsqsZ/IpOh8qrDyfLkvmJmdtM4bImUR+ajP7Q0k
 5NEkuQMNWLHew==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1n8NFL-000V8K-F7; Fri, 14 Jan 2022 14:08:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: qemu-devel@nongnu.org
Subject: [PATCH v5 4/6] hw/arm/virt: Use the PA range to compute the memory map
Date: Fri, 14 Jan 2022 14:07:39 +0000
Message-Id: <20220114140741.1358263-5-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220114140741.1358263-1-maz@kernel.org>
References: <20220114140741.1358263-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: qemu-devel@nongnu.org, drjones@redhat.com,
 eric.auger@redhat.com, peter.maydell@linaro.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

The highmem attribute is nothing but another way to express the
PA range of a VM. To support HW that has a smaller PA range then
what QEMU assumes, pass this PA range to the virt_set_memmap()
function, allowing it to correctly exclude highmem devices
if they are outside of the PA range.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 hw/arm/virt.c | 64 +++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 52 insertions(+), 12 deletions(-)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index ecc3e3e5b0..a427676b50 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -1660,7 +1660,7 @@ static uint64_t virt_cpu_mp_affinity(VirtMachineState *vms, int idx)
     return arm_cpu_mp_affinity(idx, clustersz);
 }
 
-static void virt_set_memmap(VirtMachineState *vms)
+static void virt_set_memmap(VirtMachineState *vms, int pa_bits)
 {
     MachineState *ms = MACHINE(vms);
     hwaddr base, device_memory_base, device_memory_size, memtop;
@@ -1678,6 +1678,14 @@ static void virt_set_memmap(VirtMachineState *vms)
         exit(EXIT_FAILURE);
     }
 
+    /*
+     * !highmem is exactly the same as limiting the PA space to 32bit,
+     * irrespective of the underlying capabilities of the HW.
+     */
+    if (!vms->highmem) {
+        pa_bits = 32;
+    }
+
     /*
      * We compute the base of the high IO region depending on the
      * amount of initial and device memory. The device memory start/size
@@ -1691,8 +1699,9 @@ static void virt_set_memmap(VirtMachineState *vms)
 
     /* Base address of the high IO region */
     memtop = base = device_memory_base + ROUND_UP(device_memory_size, GiB);
-    if (!vms->highmem && memtop > 4 * GiB) {
-        error_report("highmem=off, but memory crosses the 4GiB limit\n");
+    if (memtop > BIT_ULL(pa_bits)) {
+	    error_report("Addressing limited to %d bits, but memory exceeds it by %llu bytes\n",
+			 pa_bits, memtop - BIT_ULL(pa_bits));
         exit(EXIT_FAILURE);
     }
     if (base < device_memory_base) {
@@ -1711,7 +1720,13 @@ static void virt_set_memmap(VirtMachineState *vms)
         vms->memmap[i].size = size;
         base += size;
     }
-    vms->highest_gpa = (vms->highmem ? base : memtop) - 1;
+
+    /*
+     * If base fits within pa_bits, all good. If it doesn't, limit it
+     * to the end of RAM, which is guaranteed to fit within pa_bits.
+     */
+    vms->highest_gpa = (base <= BIT_ULL(pa_bits) ? base : memtop) - 1;
+
     if (device_memory_size > 0) {
         ms->device_memory = g_malloc0(sizeof(*ms->device_memory));
         ms->device_memory->base = device_memory_base;
@@ -1902,12 +1917,43 @@ static void machvirt_init(MachineState *machine)
     unsigned int smp_cpus = machine->smp.cpus;
     unsigned int max_cpus = machine->smp.max_cpus;
 
+    if (!cpu_type_valid(machine->cpu_type)) {
+        error_report("mach-virt: CPU type %s not supported", machine->cpu_type);
+        exit(1);
+    }
+
+    possible_cpus = mc->possible_cpu_arch_ids(machine);
+
     /*
      * In accelerated mode, the memory map is computed earlier in kvm_type()
      * to create a VM with the right number of IPA bits.
      */
     if (!vms->memmap) {
-        virt_set_memmap(vms);
+        Object *cpuobj;
+        ARMCPU *armcpu;
+        int pa_bits;
+
+        /*
+         * Instanciate a temporary CPU object to find out about what
+         * we are about to deal with. Once this is done, get rid of
+         * the object.
+         */
+        cpuobj = object_new(possible_cpus->cpus[0].type);
+        armcpu = ARM_CPU(cpuobj);
+
+        if (object_property_get_bool(cpuobj, "aarch64", NULL)) {
+            pa_bits = arm_pamax(armcpu);
+        } else if (arm_feature(&armcpu->env, ARM_FEATURE_LPAE)) {
+            /* v7 with LPAE */
+            pa_bits = 40;
+        } else {
+            /* Anything else */
+            pa_bits = 32;
+        }
+
+        object_unref(cpuobj);
+
+        virt_set_memmap(vms, pa_bits);
     }
 
     /* We can probe only here because during property set
@@ -1915,11 +1961,6 @@ static void machvirt_init(MachineState *machine)
      */
     finalize_gic_version(vms);
 
-    if (!cpu_type_valid(machine->cpu_type)) {
-        error_report("mach-virt: CPU type %s not supported", machine->cpu_type);
-        exit(1);
-    }
-
     if (vms->secure) {
         /*
          * The Secure view of the world is the same as the NonSecure,
@@ -1989,7 +2030,6 @@ static void machvirt_init(MachineState *machine)
 
     create_fdt(vms);
 
-    possible_cpus = mc->possible_cpu_arch_ids(machine);
     assert(possible_cpus->len == max_cpus);
     for (n = 0; n < possible_cpus->len; n++) {
         Object *cpuobj;
@@ -2646,7 +2686,7 @@ static int virt_kvm_type(MachineState *ms, const char *type_str)
     max_vm_pa_size = kvm_arm_get_max_vm_ipa_size(ms, &fixed_ipa);
 
     /* we freeze the memory map to compute the highest gpa */
-    virt_set_memmap(vms);
+    virt_set_memmap(vms, max_vm_pa_size);
 
     requested_pa_size = 64 - clz64(vms->highest_gpa);
 
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
