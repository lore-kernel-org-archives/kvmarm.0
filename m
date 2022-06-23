Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6975BC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jun 2022 07:30:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03B3F4B417;
	Thu, 23 Jun 2022 03:30:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zlwnG-tDaTLn; Thu, 23 Jun 2022 03:30:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78F4B4B3C4;
	Thu, 23 Jun 2022 03:30:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FF8E4B381
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 22:19:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IutsL83V9sEz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jun 2022 22:19:40 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D2FD24B278
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 22:19:40 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 a8-20020a25a188000000b0066839c45fe8so16027247ybi.17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 19:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=qmRSFVhsEhDBpfnqm4N8Fhb131UT2F+11PJ2keCwIs4=;
 b=qrU4bfPKoBkwTTiKfPve9s0Kfjp8vuFN1z7yGqlBJDfwPofkgZxH2msgkZnA46WpIg
 xG8zlJh5lI5v7J36zFE22Nf4NWZoPrVMg2ZGyQAjnuv5G1AZbdvGSHrUyzMRK9Md+7ud
 1l+fT1dftAhQYN7yJbaLAe0h/bU/teWnLgJkcRE+HPWctxwxdny1yeGSXwyiJLs2wifH
 kRrK6R/eCfVs5VOt4N6yOFX7UOnpfqC0hY/mE58OymHm0B7puwmwgCi+WonKm5WK/X0+
 BSndrmaGkVBWfm99WMNnpXqmrQMZdXDd+7IJAb0CsRMbaBZlDHus7yiwLKlGb0ZGx+r/
 LX5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=qmRSFVhsEhDBpfnqm4N8Fhb131UT2F+11PJ2keCwIs4=;
 b=sW3OoTwDtJ/LP8Felvqvz3LBpnYxL8Kwurv1IpVOOXxhDt5ZSCMGZCbmf3uF/OQRZu
 fe9GWt4AjUgPMsvNl9gomcTsPFHtI37rknd6Idugem63z9iZOfnRmGLOSKh4MdVY/h0U
 pvfZnin34m99zzGFJSAVe1XQCGYKh8j0s/1ubvl9/mcC1s8gceELCO9xOfRObCQuzVoQ
 B9jeDS5MC+Q3sdbMMffEG5I36GJ5vsvqPODVzSMZbmuT6EOy0QelxqO3WHkQVrIqILMm
 Wgbm0mSJbzNfR/e/JRN+mlAY62/ScK8RledmqUBPWBt1+O7HEs3lCp7HhZPy/VlP+yfr
 qzMw==
X-Gm-Message-State: AJIora+NnF5ILKLB8Vi8eoGRR1vVzrvifJOQjCFN3MgRkCmH74k34O8t
 a42fsRUjSO2vIVj7pu2pbz+YE9ebffWCSktH8D0R4q3+TBw0kcemHCTeNGhmaEoYonNKV/OhD+p
 4/St4s4Tsof7iUzRdShLOxU+qaxeOKrc+I4i5ik93Pc2c7opH2bs+kZp702OEbA==
X-Google-Smtp-Source: AGRyM1vvw84U2jyg/dWdtxTfS7KweL0nv+g/AhyHvwsGSckCZTqHtjS95hVvHN66mkERZ2IvAJ3TsBk=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:ba6f:123c:d287:a160])
 (user=pcc job=sendgmr) by 2002:a25:8887:0:b0:669:97f5:d0b8 with SMTP id
 d7-20020a258887000000b0066997f5d0b8mr5089027ybl.432.1655950780321; Wed, 22
 Jun 2022 19:19:40 -0700 (PDT)
Date: Wed, 22 Jun 2022 19:19:25 -0700
In-Reply-To: <20220623021926.3443240-1-pcc@google.com>
Message-Id: <20220623021926.3443240-3-pcc@google.com>
Mime-Version: 1.0
References: <20220623021926.3443240-1-pcc@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH 2/3] KVM: arm64: disown unused reserved-memory regions
From: Peter Collingbourne <pcc@google.com>
To: kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Thu, 23 Jun 2022 03:30:27 -0400
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Andy Lutomirski <luto@amacapital.net>,
 Will Deacon <will@kernel.org>, Evgenii Stepanov <eugenis@google.com>,
 Michael Roth <michael.roth@amd.com>, Chao Peng <chao.p.peng@linux.intel.com>,
 Peter Collingbourne <pcc@google.com>, linux-arm-kernel@lists.infradead.org
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

The meaning of no-map on a reserved-memory node is as follows:

      Indicates the operating system must not create a virtual mapping
      of the region as part of its standard mapping of system memory,
      nor permit speculative access to it under any circumstances other
      than under the control of the device driver using the region.

If there is no compatible property, there is no device driver, so the
host kernel has no business accessing the reserved-memory region. Since
these regions may represent a route through which the host kernel
can gain additional privileges, disown any such memory regions before
deprivileging ourselves.

Signed-off-by: Peter Collingbourne <pcc@google.com>
---
 arch/arm64/kvm/arm.c | 46 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index db7cbca6ace4..38f0900b7ddb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -4,6 +4,7 @@
  * Author: Christoffer Dall <c.dall@virtualopensystems.com>
  */
 
+#include <linux/acpi.h>
 #include <linux/bug.h>
 #include <linux/cpu_pm.h>
 #include <linux/entry-kvm.h>
@@ -12,6 +13,7 @@
 #include <linux/kvm_host.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
 #include <linux/mman.h>
@@ -1907,6 +1909,48 @@ static bool init_psci_relay(void)
 	return true;
 }
 
+static void disown_reserved_memory(struct device_node *node)
+{
+	int addr_cells = of_n_addr_cells(node);
+	int size_cells = of_n_size_cells(node);
+	const __be32 *reg, *end;
+	int len;
+
+	reg = of_get_property(node, "reg", &len);
+	if (len % (4 * (addr_cells + size_cells)))
+		return;
+
+	end = reg + (len / 4);
+	while (reg != end) {
+		u64 addr, size;
+
+		addr = of_read_number(reg, addr_cells);
+		reg += addr_cells;
+		size = of_read_number(reg, size_cells);
+		reg += size_cells;
+
+		kvm_call_hyp_nvhe(__pkvm_disown_pages, addr, size);
+	}
+}
+
+static void kvm_reserved_memory_init(void)
+{
+	struct device_node *parent, *node;
+
+	if (!acpi_disabled || !is_protected_kvm_enabled())
+		return;
+
+	parent = of_find_node_by_path("/reserved-memory");
+	if (!parent)
+		return;
+
+	for_each_child_of_node(parent, node) {
+		if (!of_get_property(node, "compatible", NULL) &&
+		    of_get_property(node, "no-map", NULL))
+			disown_reserved_memory(node);
+	}
+}
+
 static int init_subsystems(void)
 {
 	int err = 0;
@@ -1947,6 +1991,8 @@ static int init_subsystems(void)
 
 	kvm_register_perf_callbacks(NULL);
 
+	kvm_reserved_memory_init();
+
 out:
 	if (err || !is_protected_kvm_enabled())
 		on_each_cpu(_kvm_arch_hardware_disable, NULL, 1);
-- 
2.37.0.rc0.104.g0611611a94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
