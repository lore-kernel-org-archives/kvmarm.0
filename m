Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011037.outbound.protection.outlook.com [52.101.52.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE633FFF9D
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 23:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792191958; cv=fail; b=QoYRqSce1X/6KIC246wf0P9Z6M8jHsW27Dwgpty7XsnkboqQIPSBF6xnfgRhU0bQAY+ZbyEQfDUw7lKmX0iwcy9g1PlG2dHcEwoJJgZd7E8fK+7R4EISjVdNyazJuFEHJPkIqCO+r52kUhc/cuZkQMZ/nsTdPWN9JheiavMUdDE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792191958; c=relaxed/simple;
	bh=UiWUMFDy3YcXp7LiTIyeF4VgruLxxltoAMdqxitAN7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H5Jh9dCdkoyiCycu2FbJUEgcYyoaPBroFzVQMEilwlhmACbGoZDCVZeeJ0gyDoMBBreoFqAnkhsRa36kMT+FCwRY1+Kdxth6gMUxdHXXJ6czLF9rATVEk5P0oxXXfu9XDzWSzID6AyYMimNJ8lJt1XKkbMh5v+bxBX4u9eUkXIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OH5gc0tY; arc=fail smtp.client-ip=52.101.52.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OH5gc0tY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sTW/FmUKrKXByCdVD0LXHNa6zWHgN66yAmgv5hoeMbjmDDPniAbeRMhmkFOhBuhNG1dOd4KGyJqPY+PfpnZD4WrzlibNX8yG695lZP9cE2q0wHe8++pkN9UIfqeuFxiyRTgHhg94K2lhBWjI6owikvcLZe+nVsndk5bI9clOvtpXaO/qX+zm7BPcBdrTb7Hl/F9xm9xyk9jtAlE4RIDEvtVgdYJU7IkQI0WJmgjTIytUjo2vNWlp5BnHeKbpYLqkl9evpC2cML6TOeBCNaxANnvJPkQ+8xqrmLavjeuDE44cQce4+cSdyv8QUZw/I9wY8gMIl5zCwH6BhL+6a1Qf3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DKEdq4qHVez0dd/Lryi3y42A+YjL1u00lrpEID5N5lU=;
 b=HP3onqf9mZ71cY1uNLmuzHiEsoks9Wiuk/xTTCPx5IE/okXVgGwQyOVqxUVoG9CLbCZv5cETbp6qoCyWW/Z5eqosKTcKqwPUt27SPS4O6pqOo8ZoqvenbWRRu7+9nh3208u8tdHvQovH5eSsoSrZQNKA+/xlrW4Vh6lg+dqbhv0ZGA7EdXeib6JH3THmXyuIVcII4Jj/hU8cjZSG2FgI1vCvto/BS8Moy+fyIvzLbZzsspbnjeVw/xwNmljVKZNObbP0SMkJPKuBFAJDeb7dyImumIjztxQxOKljZpXKC1cO8DuypEETFEtv2r9P74YZfvIbRI8WHvlFu8iBFsRyvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DKEdq4qHVez0dd/Lryi3y42A+YjL1u00lrpEID5N5lU=;
 b=OH5gc0tYaq7JqweVuhCdsUiyKrNOeR/ufriDDtwEIUKMC2BaQl54gBBuDQU/JcJOk4gSubTN0iTdlaW/fCxom6cxkiLCFyV2Jh1LKO6CuCpLBzbyL1cyBxJmrrv7cKaTWpFJ7CT8W1/vzrS7r3kJdmayB6YdE6b4ki3G5Mih/v2ZEBkG9CRYtYG5vmkwkts+IVjhPWMJsQA5h2xeJQpXKHJA9xoAIR9FgCI787mNhyX4U7oXUkmqKtGSMB5Z3YFhb3CMXukqa2lZUswtfJ7IryMQwICBSkMYnyMlV4F9mdbDpuK9rCXP7m6nL4C8wCv8vaec8X23ABNfrQtog1Dw1g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5201.namprd12.prod.outlook.com (2603:10b6:610:b8::21)
 by CH9PR12MB167381.namprd12.prod.outlook.com (2603:10b6:610:314::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Fri, 16 Oct
 2026 23:05:52 +0000
Received: from CH0PR12MB5201.namprd12.prod.outlook.com
 ([fe80::fa53:495c:c3d5:243]) by CH0PR12MB5201.namprd12.prod.outlook.com
 ([fe80::fa53:495c:c3d5:243%4]) with mapi id 15.21.0522.012; Fri, 16 Oct 2026
 23:05:52 +0000
From: Deepak Gupta <deepagupta@nvidia.com>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	pbonzini@redhat.com,
	mchehab+huawei@kernel.org,
	jiaqiyan@google.com,
	oliver.upton@linux.dev
Subject: [PATCH 1/1] target/arm/kvm: handle KVM_EXIT_ARM_SEA and report BUS_MCEERR_AO
Date: Fri, 16 Oct 2026 23:05:41 +0000
Message-ID: <a4943157934f3e561781557be6e67643b479c511.1792191544.git.deepagupta@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1792191544.git.deepagupta@nvidia.com>
References: <cover.1792191544.git.deepagupta@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0062.namprd13.prod.outlook.com
 (2603:10b6:806:23::7) To CH0PR12MB5201.namprd12.prod.outlook.com
 (2603:10b6:610:b8::21)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5201:EE_|CH9PR12MB167381:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f77a8ef-1b65-46c9-548f-08df2bda066f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	nnzRQTN3rg8EjUdViO5kWiyyw3YqLFIgyQ4AYe9p70ZpmM97VLMmqvDzH4F3+ifNj60Ba3QSF66irgIjtHcAAkhoOWgtTaxh4Ykai3OzzEAW+g/p00pi26K04K76xTJZUS41G9G7Dx8Ra8BimMS9Wfn6ewvIOb7FUpYaeFZilxic3Rsh0FpNcP1qjfmWX/HasBbw1x+1CmOpeld6q8beLnyBqW8uR+3CTbiytPt/PkteifPrOQva7UYROJJ2iXbJYOLiY5XN9aBMZpACcAzospTiTNsBTPnW36bZAnIEETY6h4zeBVfVatsZorKTuW9zeC3UGU+kZMIPWfww6pfLdXM8ReAsYMBMpmgYyOUcMj9BnYEh4n73p2/LwOXZ16WxyuKH3apbMxzQ33Mh8JxJ0PEsSmkLVM+Y2qYdAUYHbBxR5olVLAq5z/a/EcRFCD1WleaBIvw8ZmU1yZPIOceYu9virT5m8KBk0vh7RafBa9qiuwcT1ppF4UazyhNXAjib3Dy6ujgCbZcBBlzgJwIJ8SncAckq6OqouUL0sttu/lcScJIF3mYWL4htCl3TdDIlnDChO4PkOXUyfPr2qZeBWoMk33BsHVpS1zP+jGmGCAfdo1LgRt4kSAc/70asdu6fozUfuGEGIdHhDxgP7MF2r0YmhsKcd/0TBHUMRxM5mhk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C+xZ6JdD4xqRJzyIqEZwS457etJBWfB/jwEy6elqxyZT/t8XpOkVzrA7iFJI?=
 =?us-ascii?Q?BXHeJ254H70SaVRJEq0jhqANGGzW67My2bkUWEvwfwl5fa0o3O9dEfUzq9qP?=
 =?us-ascii?Q?croPkSfRZtD/rGvVswJ/nFg4pXi5sis3/9o7wDHV9fU0khOo2ZwgMLZNmifn?=
 =?us-ascii?Q?7s5V1ZqkbyOg6pB/2bC6ktFiLG+e0FN93KAgeO2QzKx2LJqJQ4UtJO+5KphS?=
 =?us-ascii?Q?tmieLO/b9X9UjFTqRo1lMFG72rbXo+jTXwzPlQ8BkHyuEdJRl9ybFJR/Kb3S?=
 =?us-ascii?Q?MKGxL3gAdg5SinHWh+5nTyOpAI8oWdsLvjKXK6ZlNyW+OaM9vVsO6M4/+CZs?=
 =?us-ascii?Q?GSnk86elvkzWzqDh7TvbCQ32RhbSCpLOyFJdv142jzZNSmSHlqjQyGZ/bmDU?=
 =?us-ascii?Q?blxpjGi7bzyRI88DGYCBSYIIyZxxwhx7LWqsRByiqLsfttqZuUK0kImq+Q4x?=
 =?us-ascii?Q?ls4RYlt9HKX83h+uEE7nWmIDERxjKainMZJlkqMCWI3wfl7Tmurp5BBktKUV?=
 =?us-ascii?Q?CmFUMSX9XvybuVpVdIHl75YTUr68ocRds9OLl+vL0b28lf7vSG0mZNwktKAH?=
 =?us-ascii?Q?rq/x+7HcBAVX2XkrCxH0XiG83GWtt9HQvCKGoQ34sSpSd9HIVudJ5Tkr2sn+?=
 =?us-ascii?Q?k4sMrQbTVNP9r6iB8WpD/28bHb0nE3G6nUGwf+rFyM+axXvVcQnhKzTMFJ+P?=
 =?us-ascii?Q?3tzYD5keW1OOEYiGReefbjstUehrEhWFnlamzZeowe/d5AYuycpWqVnodkjq?=
 =?us-ascii?Q?JOI6r1UnTi8pIA0cHzymnAx7/jfCLB0PbkBg12RbZzcY5GZYRJmWwTPjPkJa?=
 =?us-ascii?Q?eL7SvVdmn3asHYFi920+kA810OOoVTRME1CbkZ/XDGSFKjYZOGmmsGUBCc+y?=
 =?us-ascii?Q?qNqiSTG2w/LCgbpRi2+beELwAu4XkDezM+tvlXtwrWyOutnvQsG06jUwH+o9?=
 =?us-ascii?Q?YsfqH6bKLwqkw9sSNyCH+fd5qIirpdR+lKLoesRf5C/Cx0aNpNs+eHBT5Xux?=
 =?us-ascii?Q?4/3BeZJGEpockKJNHnXbnN7UBu7LLus5VjdXSgdzGhFr08BCvy0B4FlAJr3E?=
 =?us-ascii?Q?hu0Y6cnlJB33KFc9Hkqezn9UtVECEti8cIE2KNMFfw0qWEM8ImtLE8CJnI+1?=
 =?us-ascii?Q?93k+0NqWf9i8yfPiDXFJg5XciMBJrtEtO2LLBrC3A8JYbHNlSsTm5Ha5ll5P?=
 =?us-ascii?Q?qVScCMn0TBp3YL8UyXgVbGc6wj4IedMsiSPNiLYmRcQdipKNVTj5BZUO6ewW?=
 =?us-ascii?Q?Z7kzA6dvjVfVf64mobsGbMR3ya174OwA56zFR1Z1GDZprpQ6JaNOLjfLUDVQ?=
 =?us-ascii?Q?CDKWrTeOgD5RdNVRMqvlVNYwIPexedP5yqPSoQnQX2By7QLPBhyTBgNkCOek?=
 =?us-ascii?Q?Pga4Tkja7Kh8PBBqpGect5y07zOYhVCuIZLRuIRJCWkeYFv8A4aRw2i/Ha3p?=
 =?us-ascii?Q?Jb1F6GLr14fk/LGlOwzzQ8yDn+eh8fCQwfOSR1LeAaPHg3HCMnPybKveLNsM?=
 =?us-ascii?Q?jpCBvEcD4Mou0ZfGy1Em+N6ZmfE7Y9yJL/8ZxE3k0k01cAB+B9T9GnGGhZ7X?=
 =?us-ascii?Q?Hp1lNRKfac82A6LfKNup+fDsKIYbOXGoVNVNlBOvsxFRkgG+fwLYFLj3fxya?=
 =?us-ascii?Q?LPpZtMa2QhyTishhwx7ERYiMaOwNUGkwQuxx4S852PcSybaTnLrOMXWx0dwC?=
 =?us-ascii?Q?B6iGYMd9iewNr4s9HBg7/TRuKz7FCu8w/FCtsYShzdp1MhGmdhozj9ONyRUf?=
 =?us-ascii?Q?XSVe6Tp8sQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f77a8ef-1b65-46c9-548f-08df2bda066f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 23:05:52.1852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A5FA8TQHD8hXAvj43eoXeat/nbiDiw/FrcF8ODDyaznPiYbxj2bpMLlWbMTJD3IsrlHrKWOnyo4IU/Zc4lP/EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH9PR12MB167381

Linux 6.19 added KVM_CAP_ARM_SEA_TO_USER: a guest synchronous external
abort (SEA) that the host cannot attribute to a firmware-first (APEI)
error record is returned to userspace as KVM_EXIT_ARM_SEA instead of
being injected as a virtual SError. Linux guests treat that SError as
fatal, so on a host whose HEST has no SEA-notified GHES source every
guest-consumed memory error currently panics the guest.

Enable the capability when KVM offers it and handle the exit:

 - If the exit carries a guest physical address backed by guest RAM,
   mark the page for remapping on reset and record a memory error on
   the synchronous GHES source, as the BUS_MCEERR_AR SIGBUS path does.

 - Inject a synchronous external abort into the guest. KVM hands us
   ESR_EL2 sanitised to EC, IL, FnV, EA, CM, WnR, xFSC and SET, and
   FAR_EL2 when FnV is clear. Generalise kvm_inject_arm_sea() to take
   syndrome and FAR and pass them through, so the guest sees an
   instruction or data abort with the real fault status code and a
   valid FAR when the hardware provided one. The SIGBUS path keeps
   injecting the data abort with FnV set.

 - The exit may carry no address at all (FnV set, no HPFAR_EL2). The
   host's memory_failure() tells us the page later via BUS_MCEERR_AO,
   so far only acknowledged with a TODO: report it on the GED-notified
   GHES source so the guest offlines the page too. Machine types up to
   virt-10.0 have no such source; warn and drop the record there.

The exception is emulated with arm_cpu_do_interrupt() rather than via
KVM_SET_VCPU_EVENTS' ext_dabt_pending, which can only produce a data
abort with FAR taken from the last exit, while the exit may be an
instruction abort or have no valid FAR. With ras=off the guest only
gets the external abort, still better than the SError. A host without
the capability is unaffected. A trace event records every exit.

Tested on an arm64 host whose HEST has only GSIV- and SDEI-notified
sources, injecting an uncorrectable memory error with EINJ into a page
mapped by a guest and consuming it from a guest process: without this
patch the guest panics with an SError; with it the process gets SIGBUS,
the guest marks the page hwpoison and stays up.

Link: https://lore.kernel.org/r/20251013185903.1372553-2-jiaqiyan@google.com
Signed-off-by: Deepak Gupta <deepagupta@nvidia.com>
---
 target/arm/kvm.c        | 164 +++++++++++++++++++++++++++++++++++-----
 target/arm/trace-events |   1 +
 2 files changed, 146 insertions(+), 19 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 3d905f8565..8f18bee285 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -38,6 +38,7 @@
 #include "hw/core/irq.h"
 #include "qapi/visitor.h"
 #include "qemu/log.h"
+#include "qemu/rcu.h"
 #include "hw/acpi/acpi.h"
 #include "hw/acpi/ghes.h"
 #include "target/arm/gtimer.h"
@@ -52,6 +53,8 @@ static bool cap_has_mp_state;
 static bool cap_has_inject_serror_esr;
 static bool cap_has_inject_ext_dabt;
 
+static int kvm_arm_handle_sea(ARMCPU *cpu, struct kvm_run *run);
+
 /**
  * ARMHostCPUFeatures: information about the host CPU (identified
  * by asking the host kernel)
@@ -674,6 +677,21 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    /*
+     * Ask KVM to return a guest synchronous external abort that the host
+     * could not attribute to a firmware-first (APEI) error record as
+     * KVM_EXIT_ARM_SEA, instead of injecting an SError with an
+     * IMPLEMENTATION DEFINED syndrome into the guest. Linux guests treat
+     * that SError as fatal, so on a host whose HEST has no SEA-notified
+     * GHES source every guest-consumed memory error would otherwise be a
+     * guest kernel panic. See kvm_arm_handle_sea().
+     */
+    if (kvm_check_extension(s, KVM_CAP_ARM_SEA_TO_USER)) {
+        if (kvm_vm_enable_cap(s, KVM_CAP_ARM_SEA_TO_USER, 0)) {
+            warn_report("Failed to enable KVM_CAP_ARM_SEA_TO_USER cap");
+        }
+    }
+
     if (s->kvm_eager_split_size) {
         uint32_t sizes;
 
@@ -1599,6 +1617,10 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
             ret = EXCP_DEBUG;
         } /* otherwise return to guest */
         break;
+    case KVM_EXIT_ARM_SEA:
+        /* Guest SEA that the host could not claim through APEI */
+        ret = kvm_arm_handle_sea(cpu, run);
+        break;
     case KVM_EXIT_ARM_NISV:
         /* External DABT with no valid iss to decode */
         ret = kvm_arm_handle_dabt_nisv(cpu, run->arm_nisv.esr_iss,
@@ -2106,29 +2128,107 @@ int kvm_arch_destroy_vcpu(CPUState *cs)
     return 0;
 }
 
-/* Callers must hold the iothread mutex lock */
-static void kvm_inject_arm_sea(CPUState *c)
+/*
+ * Inject a synchronous external abort into the guest, targeting EL1.
+ *
+ * @esr: the syndrome to present. Its EC selects an instruction or a data
+ *       abort (the same-EL variant is chosen here); IL and the ISS bits
+ *       (FnV, EA, CM, WnR, xFSC, SET) are passed through to the guest.
+ * @far: the faulting virtual address, only meaningful when ISS.FnV is 0.
+ *
+ * Callers must hold the BQL.
+ */
+static void kvm_inject_arm_sea(CPUState *c, uint32_t esr, uint64_t far)
 {
     ARMCPU *cpu = ARM_CPU(c);
     CPUARMState *env = &cpu->env;
-    uint32_t esr;
+    uint32_t ec = syn_get_ec(esr);
+    bool iabt = ec == EC_INSNABORT || ec == EC_INSNABORT_SAME_EL;
     bool same_el;
 
-    c->exception_index = EXCP_DATA_ABORT;
+    c->exception_index = iabt ? EXCP_PREFETCH_ABORT : EXCP_DATA_ABORT;
     env->exception.target_el = 1;
+    env->exception.vaddress = far;
 
-    /*
-     * Set the DFSC to synchronous external abort and set FnV to not valid,
-     * this will tell guest the FAR_ELx is UNKNOWN for this abort.
-     */
     same_el = arm_current_el(env) == env->exception.target_el;
-    esr = syn_data_abort_no_iss(same_el, 1, 0, 0, 0, 0, 0x10);
-
-    env->exception.syndrome = esr;
+    ec = (iabt ? EC_INSNABORT : EC_DATAABORT) + same_el;
+    env->exception.syndrome = syn_set_ec(esr, ec);
 
     arm_cpu_do_interrupt(c);
 }
 
+/*
+ * Handle KVM_EXIT_ARM_SEA: the guest took a synchronous external abort,
+ * typically by consuming a poisoned memory location, and the host kernel
+ * found no APEI error record to claim it with. Without
+ * KVM_CAP_ARM_SEA_TO_USER, KVM would inject a virtual SError here, which a
+ * Linux guest treats as fatal.
+ *
+ * Do what the BUS_MCEERR_AR SIGBUS path does: when the exit carries a guest
+ * physical address that is backed by guest RAM, remember the page so it is
+ * remapped on reset and record a memory error on the synchronous GHES
+ * source (if the machine has one, i.e. ras=on), so the guest's
+ * memory_failure() can isolate the page and kill only the affected task.
+ * Then inject a synchronous external abort that reflects the original one:
+ * the kernel hands us ESR_EL2 sanitised to EC, IL, FnV, EA, CM, WnR, xFSC
+ * and SET, which are exactly the fields that are meaningful at EL1, and the
+ * faulting virtual address when FnV is clear.
+ *
+ * kvm_arch_handle_exit() runs without the BQL; both the GHES update and
+ * arm_cpu_do_interrupt() need it.
+ */
+static int kvm_arm_handle_sea(ARMCPU *cpu, struct kvm_run *run)
+{
+    CPUState *cs = CPU(cpu);
+    uint64_t flags = run->arm_sea.flags;
+    uint64_t esr = run->arm_sea.esr;
+    uint64_t gva = run->arm_sea.gva;
+    hwaddr gpa = run->arm_sea.gpa;
+    ram_addr_t ram_addr = RAM_ADDR_INVALID;
+    AcpiGhesState *ags;
+
+    trace_kvm_arm_handle_sea(flags, esr, gva, gpa);
+
+    if (flags & KVM_EXIT_ARM_SEA_FLAG_GPA_VALID) {
+        MemoryRegion *mr;
+        hwaddr xlat, len = 1;
+
+        WITH_RCU_READ_LOCK_GUARD() {
+            mr = address_space_translate(&address_space_memory, gpa, &xlat,
+                                         &len, false, MEMTXATTRS_UNSPECIFIED);
+            if (memory_region_is_ram(mr)) {
+                ram_addr = memory_region_get_ram_addr(mr) + xlat;
+            }
+        }
+    }
+
+    bql_lock();
+    kvm_cpu_synchronize_state(cs);
+
+    ags = acpi_ghes_get_state();
+    if (ram_addr != RAM_ADDR_INVALID) {
+        kvm_hwpoison_page_add(ram_addr);
+        if (ags) {
+            Error *err = NULL;
+
+            if (!acpi_ghes_memory_errors(ags, ACPI_HEST_SRC_ID_SYNC, gpa,
+                                         &err)) {
+                warn_reportf_err(err, "KVM_EXIT_ARM_SEA at GPA 0x%" HWADDR_PRIx
+                                 ": ", gpa);
+            }
+        } else {
+            warn_report_once("KVM_EXIT_ARM_SEA at GPA 0x%" HWADDR_PRIx
+                             " but the machine has no GHES (ras=off): the "
+                             "guest only gets an external abort", gpa);
+        }
+    }
+
+    kvm_inject_arm_sea(cs, esr, gva);
+    bql_unlock();
+
+    return 0;
+}
+
 #define AARCH64_CORE_REG(x)   (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
                  KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
 
@@ -2525,19 +2625,45 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
             /*
              * If this is a BUS_MCEERR_AR, we know we have been called
              * synchronously from the vCPU thread, so we can easily
-             * synchronize the state and inject an error.
-             *
-             * TODO: we currently don't tell the guest at all about
-             * BUS_MCEERR_AO. In that case we might either be being
-             * called synchronously from the vCPU thread, or a bit
-             * later from the main thread, so doing the injection of
-             * the error would be more complicated.
+             * synchronize the state and inject an error: a data abort
+             * with DFSC = synchronous external abort and FnV set, which
+             * tells the guest that FAR_ELx is UNKNOWN for this abort.
              */
             if (code == BUS_MCEERR_AR) {
                 kvm_cpu_synchronize_state(c);
                 acpi_ghes_memory_errors(ags, ACPI_HEST_SRC_ID_SYNC,
                                         paddr, &error_fatal);
-                kvm_inject_arm_sea(c);
+                kvm_inject_arm_sea(c, syn_data_abort_no_iss(0, 1, 0, 0, 0, 0,
+                                                            0x10), 0);
+                return;
+            }
+
+            /*
+             * BUS_MCEERR_AO: the host has retired a page of guest RAM that
+             * no vCPU was accessing at the time. We may be on a vCPU thread
+             * or on the main thread, in both cases under the BQL, so there
+             * is no vCPU to inject into. Instead record an action-optional
+             * memory error on the GED-notified GHES source, so the guest
+             * can offline the page as well. That source only exists with
+             * the HEST layout that reports its address to QEMU (virt
+             * machine versions after 10.0); with the older single-block
+             * layout the record would land in the synchronous source's
+             * block, unnoticed by the guest, and block the next
+             * synchronous record.
+             */
+            if (!ags->use_hest_addr) {
+                warn_report_once("BUS_MCEERR_AO at GPA 0x%" HWADDR_PRIx
+                                 ": this machine type has no GED-notified "
+                                 "GHES source, the guest is not told",
+                                 paddr);
+            } else {
+                Error *err = NULL;
+
+                if (!acpi_ghes_memory_errors(ags, ACPI_HEST_SRC_ID_QMP,
+                                             paddr, &err)) {
+                    warn_reportf_err(err, "BUS_MCEERR_AO at GPA 0x%"
+                                     HWADDR_PRIx ": ", paddr);
+                }
             }
             return;
         }
diff --git a/target/arm/trace-events b/target/arm/trace-events
index 8502fb3265..5c78d1255c 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -13,6 +13,7 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
 
 # kvm.c
 kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
+kvm_arm_handle_sea(uint64_t flags, uint64_t esr, uint64_t gva, uint64_t gpa) "KVM_EXIT_ARM_SEA flags 0x%"PRIx64" esr 0x%"PRIx64" gva 0x%"PRIx64" gpa 0x%"PRIx64
 
 # cpu.c
 arm_cpu_reset(uint64_t mp_aff) "cpu %" PRIu64
-- 
2.53.0

