Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373EC47DD79
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 12:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788524696; cv=none; b=SRr+/gbixYLN9FiZerXMgmDXmB2av+Obc9XzPtIDu0lSuYVi+rHSuJhaXyVQiGdhm9JQC18dK68fhCNL32kEDS4ZIIxRL3yre2B+SxJZ7o5RnIgFmGQkpvP5GWUlW09Pp25vWyLveL8799SKaj9PKluW3DQ0f8zrSX1YKvjuTOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788524696; c=relaxed/simple;
	bh=f8aGNyC4hhuimPFgaao0DU0lrWnNx6TAWDdKIId6TYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnotAsXm4XNGoLktzd1NeQ6x7hyZpJaChLbEvmdl+Sh+EKYYi+Ph7JexXgxh6HLELWj894JfNdheGNXRifZ7MqigPrPsSJLQ+QE0rh/7h6wXLXPB6cyRbaE6YRKCkWnTOdb9PEaE6JAViuVritpC0jg3fVtLYV/Hii380z48oHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qNNPBITn; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qNNPBITn"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3990fe066ebso706241a91.1
        for <kvmarm@lists.linux.dev>; Fri, 04 Sep 2026 05:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788524694; x=1789129494; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dSrYA1DkzHEof4sMwyJ4ZJLRu5Ytzn/ZSPLCLv7l2KM=;
        b=qNNPBITnMvdTumIe2N9FmcRQgVYt9T1vHnKC2iCsLeNKYWV6psioeDTIcsUHo897zF
         3lSljUw1RqZ6qMnkBLxFxOqtVvUvopY6tHHlEGOVO3mMlx4IMlcmn4lNUU5qXshg5ImW
         1hlsMIIi+K/ZETNnqj1OHMkNL58ao5xbSREHiTN8lQcBFUytx8IMUMrd2F12bu2dRa3B
         o5oIcZMtlgShKfdAnsUQMvS/4LNHgnlF0tiRKrVOFcQ0CWwNWx8Bj73H/ONjSNH+jBnL
         J8sVIsYIqD4i/B1IJkFpDcEdgmJZ57YRdkObzt9Mt/KSfDmSd0IKqKMBbKmh7gcoXdp1
         9kZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788524694; x=1789129494;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dSrYA1DkzHEof4sMwyJ4ZJLRu5Ytzn/ZSPLCLv7l2KM=;
        b=NVinDO+4fh9x5F5h7+YAKdxnV7iRju0oQdK2kioKdd1EBK37Pq5XPuNxU7EfTwnu1r
         7E7DlR6FVB5aMaZpYhQGsNPcu6wFg21iswH8K0HrYZtjIplhgOUoPxLJ92FVnbS4YpLH
         7+6pXnAWiP560DQE4XRclnRWIquS5xJTnka6KwGWiYuANZQzEhORLkeDvC88AhlPfgps
         8zTyPz68DZ/yLT3hImjHepXluxaBKzt2/ZCenH+HlKU37RfKVCOzqRbJi9y+ssnkhUdi
         kTD7A7z9eS5n+YH/+U+7OlrE1sWVEDEKa+UBxM8TaPdpGUtDI+66j2o0yttu1UxR8/7b
         0Gkw==
X-Forwarded-Encrypted: i=1; AKwUvBwZonUqy6+uGXSC78d0ZfEOAtrvL6q5F7IEg+/2UjXgwIT7cHw/lXvwGPQLBtnymVJ8f19xu1k=@lists.linux.dev
X-Gm-Message-State: AFuF++lLLEzkLVi8VHgwqlHseq4XNxKxr+0RkwbAopN3cwkLFwkI/Dw+
	epSnFiYIpHhH/68KW64yUksqbLfxyse7d4wFAm2uT4wAoWKFqHiOxA03
X-Gm-Gg: AYBFou1WKI/5LqzXzcIacsU61deav6f+NXSF5ciBosxi7snfMhbWdXnroT1lHmzcJok
	f0eh4vpVq02MSTH6lYinejFz+enT53P0Ye5BQfSulZZ4mCRddC8GggxZWjCnQgrxEjcToIWh/hk
	vwDs9itOzQicraLULNMsUiSa/igdUKZ04GoFwC6BowDcPGkXEUXkSiWYZ5WFmJ0KR0+fN61wk0y
	qZqDIs2Q+cnbyXagrEM/RLVf7bmw9Jy4lWz4PkrqznKXb3CcvDLoIcmx7Tjy0WQub4KAJl+ZCI6
	lUkRHMg1AfgRah4pew9Ri3wvW8O56Ye6jg0YNgTfHtWieR1QXLG2UVSvbsBhjyMvwbaa27VUChH
	Mh/wKQ0m2go+sCYlHnl0SLGfQX7ckCnCXplLmEBZT5Mutehhe/7A/nuvunealYFG0/onpLTVmIF
	8rsZQvlCE63vuZ1JE6Cw3gOIe/hjOdegOMBWkXpj5/7Sb1fG2XwuVyLIAppQx+9GsgXmnseg0oh
	8hEh29YQVONAH1QqmPkc5TmMzk=
X-Received: by 2002:a17:90b:2e52:b0:38d:ddc2:7ccb with SMTP id 98e67ed59e1d1-39b260dd3efmr8705280a91.1.1788524694319;
        Fri, 04 Sep 2026 05:24:54 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339b8f787esm5880860eec.23.2026.09.04.05.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 05:24:53 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH 1/3] arm64: kvm: fix typo "synchonized" in comment
Date: Fri,  4 Sep 2026 17:54:40 +0530
Message-ID: <20260904122445.31163-2-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260904122445.31163-1-hemanth.selam@gmail.com>
References: <20260904122445.31163-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct "synchonized" to "synchronized", reported by scripts/checkpatch.pl
using the misspelling list in scripts/spelling.txt.  Only touches comments,
no code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 arch/arm64/kvm/hyp/entry.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 308100ed25de..9709905f21b5 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -46,7 +46,7 @@ alternative_else_nop_endif
 
 	// Ensure that __guest_enter() always provides a context
 	// synchronization event so that callers don't need ISBs for anything
-	// that would usually be synchonized by the ERET.
+	// that would usually be synchronized by the ERET.
 	isb
 	mov	x0, #ARM_EXCEPTION_IRQ
 	ret
-- 
2.48.1

