Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2922620EE
	for <kvmarm@lists.linux.dev>; Fri, 18 Nov 2022 06:00:10 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id v17so3706820plo.1
        for <kvmarm@lists.linux.dev>; Thu, 17 Nov 2022 22:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie-ntu-edu-tw.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=q4Wk+KzFpp8McF2mDNBn6lyFAwa5ExYeoo2v/dCLoXE=;
        b=F6o5IA2rQckRHAgrVgFVJsNGoM3dOXI/T05L8otWp8O0NUh4J5fPSDaGJp7VPnkp/2
         OTEXlejbStDWGw5Vw3VHFjA91SPh974r6KgoVy5BP7pIkGnMhcYn/Hcm8XXyLChcklDX
         Yuslm1FkyrYoG/q1m/IES0FpKMEh2aQoap3ZUskMIQ0MUZXvCtPBdKMFLa3t1upZ4i5G
         iaGoJit0pUb/g9OX5fjyVx+k3yQFbgEXmew9glBZeLVJBh4ryqUyhOS+/PtHW62Ejzl8
         kieaLjS/C1/R7a/NVlpNLlhQXM3PfNaBo/kVr1GLa57CgplAeDpIUKxaT1M6cmRxwStU
         4pBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q4Wk+KzFpp8McF2mDNBn6lyFAwa5ExYeoo2v/dCLoXE=;
        b=cDmyykjaxceH7L8HVfEAY3e+TUAxROITg76rj7NkQJm14TU+8PjjjBPWR63eV86392
         TTyMYA3wFgdm71QDJy/0UofuyFKnOJTrgzuYLkitTW056X1NpH4bgtprv6hpUYvaq8fh
         uyJTl19ul1Ahicl85cRZI5W7tErStUnpdW0Py9Og7vGxEDkH2BqDfIgDoLAPAKxEUBnb
         zd7lfmDY6kDGMBTvZeO+0rPW7f4+/lOkdkXU0eE9cgU/aLQHDGKotEX9w+04c/LKBlWx
         ZxjDnV8c8uPltJSCf3UVftvYkLCBRNaE01nFhXGsqLpPDzXIkbjBzva94CjtTLs3RbOI
         5O2w==
X-Gm-Message-State: ANoB5pktrDjRv3NEFtILDMEX4JmzrZZBBWqLhgu0CRdtL7Hn8jx/Bf7V
	FhR4k2Mng7t0LFGsnXpI5B9zLu2weaPvSSyKsdmkKVSd5nZXe2P6iQCAe5klmn32W+BVfYBGsnc
	ufhGf1JUiK7unqP8ROwn1J1x8tNwYgpeqAJDW91s/X8AY0Cl5G95XGzKATmoeImookI6/jLsRvR
	VYhHm8O/V2LSiZePHBVTo=
X-Google-Smtp-Source: AA0mqf7JGkj+dhtm+n3CMsmmaicX6T43PbeSs87rwh9x5tEbgbshfwL2GcJwh/+hs46IiO5iW+Axqw==
X-Received: by 2002:a17:90a:6904:b0:208:4bfa:51e1 with SMTP id r4-20020a17090a690400b002084bfa51e1mr11873419pjj.228.1668751210234;
        Thu, 17 Nov 2022 22:00:10 -0800 (PST)
Received: from localhost.localdomain (2001-b011-3803-1a96-3716-7fae-2678-9ea1.dynamic-ip6.hinet.net. [2001:b011:3803:1a96:3716:7fae:2678:9ea1])
        by smtp.gmail.com with ESMTPSA id h9-20020aa796c9000000b0056d98e359a5sm2169627pfq.165.2022.11.17.22.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 22:00:09 -0800 (PST)
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: maz@kernel.org
Cc: james.morse@arm.com,
	alexandru.elisei@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org,
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
Subject: [PATCH v2] KVM: arm64: Update comment of create_hyp_mappings
Date: Fri, 18 Nov 2022 13:59:37 +0800
Message-Id: <20221118055937.14605-1-r09922117@csie.ntu.edu.tw>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Gm-Spam: 0
X-Gm-Phishy: 0

HYP_PAGE_OFFSET is removed since 4.8, and the method for generating Hyp
VAs has evolved. Update the functional description of
create_hyp_mappings accordingly.

Signed-off-by: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
---
Changes in v2:
 - Take Marc's advice

 arch/arm64/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8f26c6569..6dda4f4bd 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -479,7 +479,7 @@ void kvm_unshare_hyp(void *from, void *to)
  * @prot:	The protection to be applied to this range
  *
  * The same virtual address as the kernel virtual address is also used
- * in Hyp-mode mapping (modulo HYP_PAGE_OFFSET) to the same underlying
+ * in Hyp-mode mapping (modulo a random offset) to the same underlying
  * physical pages.
  */
 int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
-- 
2.34.1

