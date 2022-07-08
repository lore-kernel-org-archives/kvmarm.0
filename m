Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C5CC43334
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jul 2022 09:43:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FA264BA9B;
	Mon, 11 Jul 2022 05:43:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mMjtVl2qZyhr; Mon, 11 Jul 2022 05:43:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58D494BAB1;
	Mon, 11 Jul 2022 05:42:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A06CA4B596
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jul 2022 17:21:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x3cmaq2+bf42 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jul 2022 17:21:19 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6E3FE4B58D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jul 2022 17:21:19 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-31c9a49a1a8so279677b3.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jul 2022 14:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=d06KtJGM9Urh+hEma1oe+1DCWv79kZEo+4GAAOkgM9k=;
 b=oQDT6Wq7kEbhP3BM0f12sQqelVDyuIBAdNcbuWk1GGVjjUSN1gd5aAKSBazbYqFS4K
 +arOzs7jC2zDxprNY10dM8KLjkEYfomASm4epKLHtGTSor91ZAwLYfV5t0WmZjdt/Z4O
 vACDN7b5l6kICT11HPPKfdfBk2O8d9ITJsAyLdFuTFiEQLLoDPCM58N3u6CiOZzQvKSH
 s3gAaUaVxHr/Co94+2LthvqvFUXhIY9DH6eoOuoA2qViPNkh72I32WcBfGyOYgoqiBMM
 80/uUyzDRSTU4pwtkVhUeJAn3GLyj0tD++8Zd2IcqMvG6kcz0FDO8avyiv4s16nl/HHr
 wu9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=d06KtJGM9Urh+hEma1oe+1DCWv79kZEo+4GAAOkgM9k=;
 b=rQASFg1RX7v0/JuHDlhZ83B94nR5jFFOx5bXBVPdNpskGeKj2x3hARLSkMkABw5kfn
 RMQTETOK7lhnerYWpyuhPDUiirVeoZX5AqBqh6KTzxl8MBSc5tjbtzuCcBE1AOO8HDrF
 bibmYhMgE3vic0pwJPVYx9W9Ex38IXsxgiS7Y6AxM151zQY7GhCd8p7hHuUd+OT1nhEu
 OjPf7N1KLDat4Khe4GqRe2U2slASKwQh+9mpMp8BYRSs/CKdbYVcHRNlR7QSx+QrRwZZ
 ry0iFvXWqEyaooOCu7n6CcgDtlzwlUedmJTIorggBGj0zSKRHkJkHxNdKq/cfuMJsisx
 /2Wg==
X-Gm-Message-State: AJIora8ebV/+PzR+aJyBPEF53txCoMO5TLrHY/pPGCwo6irRgMom9Dug
 e11RXFpN7aNGNDpbE9TsVJxAfh1Qtr87IIgwSWOReY3nK85KoNIw3WDETsSralPuxnaW2Nhqbj5
 MC6UrAaeb/GV9lQQNNrcdU1BM6aoApQ5YPN3yJhwxkUVAgoNAXjvmxry7VYRpfA==
X-Google-Smtp-Source: AGRyM1vfmvu7rG+koN3KOKJWw2zBTYS3L0eEAox4rXFwqECYm1TTG82R1SDiGf/lpsF8NErbOex4Qe4=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:ff27:d65:6bb8:b084])
 (user=pcc job=sendgmr) by 2002:a25:6b0b:0:b0:66e:445a:17bb with SMTP id
 g11-20020a256b0b000000b0066e445a17bbmr5638981ybc.147.1657315278964; Fri, 08
 Jul 2022 14:21:18 -0700 (PDT)
Date: Fri,  8 Jul 2022 14:21:05 -0700
In-Reply-To: <20220708212106.325260-1-pcc@google.com>
Message-Id: <20220708212106.325260-3-pcc@google.com>
Mime-Version: 1.0
References: <20220708212106.325260-1-pcc@google.com>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH v2 2/3] KVM: arm64: disown unused reserved-memory regions
From: Peter Collingbourne <pcc@google.com>
To: kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Mon, 11 Jul 2022 05:42:55 -0400
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
index c1fc4ef82f93..91ca128e7daa 100644
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
@@ -1913,6 +1915,48 @@ static bool init_psci_relay(void)
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
@@ -1953,6 +1997,8 @@ static int init_subsystems(void)
 
 	kvm_register_perf_callbacks(NULL);
 
+	kvm_reserved_memory_init();
+
 out:
 	if (err || !is_protected_kvm_enabled())
 		on_each_cpu(_kvm_arch_hardware_disable, NULL, 1);
-- 
2.37.0.144.g8ac04bfd2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
