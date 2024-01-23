Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10CD612F9
	for <kvmarm@lists.linux.dev>; Tue, 23 Jan 2024 00:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970758; cv=none; b=RdXSay3S5qEzjfrPaGZ1XReka8VpRR+BU5zf4ii6XQTCv1WtdDEf7ShMxt4a0wcmkmWcIy6RF5xl9WP7zJE+GDwbLmHyKccfgyHeHTSDis37QPAiiz9sfnr0tYVloCcB98exaqaAdg7f8ekc5qcqxcm9F4WgzAXdkpEO7JZgWMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970758; c=relaxed/simple;
	bh=jUfBRygKEob0pYY7t7xuNdNYLn6sNoLNNiaAx8Qo6NY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hVl+m3cfBTHfm/GZNZccsjbg64Y0Med3S4bcwi0SDTi2q3aRHUNauZGWmw54QKFpZi4Tq6vy2NQXmNYqvNKgFZUNKcYpqqkp1iHAJZb4F+viHDrVQOSKbnXtptvtAmVcxkcvh6cqmIAYn1lno8RcKcQFEqv78lvNgu1V5jywV+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=jiBazPuj; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jiBazPuj"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-5955a4a9b23so2243587eaf.1
        for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 16:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1705970756; x=1706575556; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E9D2RhyYqAg2d9K0ImTDYoiLNMME5NOa6lhB+xLPfvo=;
        b=jiBazPujaix2f7jrwaLxh53My+UNgrCpj2i+kvernjDrCwOCalBFDcRquWPG2PdLrQ
         jhSMTY0gqH+isuzaa3sqpGDnE+rudc9mSJ2tjGAVhY669TI8QuFUNB9nYU8GvKZWK6PI
         K6q64i2rOsA8Tn7zbZjGMSxYizT6Nogu6DjBY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705970756; x=1706575556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E9D2RhyYqAg2d9K0ImTDYoiLNMME5NOa6lhB+xLPfvo=;
        b=L+ty9DvoSnr9okoDnidPVQ2jH0rR6TQ3g8rGuyWpJJYO9rip7P954Cdk4qQ4jIsbQs
         fnzsKFMlWA2sw25UNBN/Omyc+e4nQz+sPR+3ear6VWajKjhQZBuozFtI7b0DHJVGANzY
         3OKOfJW6UiOcpJgo7J5wpzX7YYmSeUyfO2l/eir+OapxRlRiin1CNH3Ztbdjnp+6Booo
         YV1hBGxoM6KWguw6Jsm37J/v3SA50/Vr9K78S+RDTi/dxXiupNXwmW6Sz0cqv6WSGbk/
         MV07cJ2oy7IFuVtng7npmrYe9GC99XSxSVICsu0anvqTQlbCKV71C4FX3nYDEVMP8szO
         pm5A==
X-Gm-Message-State: AOJu0Yy6hwGr+Db7BvTUMaMg1xYNghfrX0YPFyoG9WSJR/vKKNZvEPbl
	ToSOOz+5u+ipCWi0djT1+v+zIH7cSN2TbjQUcN7PfGZKFg917I5CNzbQq8weFA==
X-Google-Smtp-Source: AGHT+IFVISzrzSXSdVQ6Q9UgTnrk65aK8T32BzTL9w9bZOjlyVv+fDCi/DNB3qZ7M7Yj6ydPIU0wGg==
X-Received: by 2002:a05:6358:9044:b0:171:4aa4:51 with SMTP id f4-20020a056358904400b001714aa40051mr2836525rwf.54.1705970755743;
        Mon, 22 Jan 2024 16:45:55 -0800 (PST)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id q24-20020aa79838000000b006dba11edc7csm9613217pfl.218.2024.01.22.16.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 16:45:54 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: linux-hardening@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 57/82] KVM: arm64: vgic-v3: Refactor intentional wrap-around test
Date: Mon, 22 Jan 2024 16:27:32 -0800
Message-Id: <20240123002814.1396804-57-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240122235208.work.748-kees@kernel.org>
References: <20240122235208.work.748-kees@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2103; i=keescook@chromium.org;
 h=from:subject; bh=jUfBRygKEob0pYY7t7xuNdNYLn6sNoLNNiaAx8Qo6NY=;
 b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBlrwgK6p/l1eSrerQhSuQAXGj4NB7+sc1cNpXou
 bSA7eeLunuJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZa8ICgAKCRCJcvTf3G3A
 JvcVEACO/+PPMjBquDJGhsJWwJDHC0YCgObRXdZAVFrFSsIROk0VLyG5+vouD43LP2qVe5ORA5j
 bl5cVYkqVOrsAC8uQaB+9i/mDFxTvj5VHQm1TUR2xuP827NRLV0VGb2f9Fj/FPIjyevrbu0PcMA
 UcER3p5QpR/cuOZBj3R/vah7DqHmaIne4dZAW9p54Oi514wjbLYhIfwOSVCQL6DDgGIxtnATzDD
 rAetbVwGi503y+FO6LYOjI422f/21hmyOca1/u/ISsjjrgZO428LuNq+QUdmIip/pVhEsXw8ww/
 p6vIlHQPoGVgnE7c+USyPLwZ3CV0VXxY5SD2sAnDH2sBy1akaJOFxzQW/An8acwegGir2tjE+9z
 hio1KXTg8hgdaASg3zurlSyzb/NdXrjdSN6i2SO3oMHjyswNoYDG6syzHtssPhYvXSMwoORpOb6
 Nx1W3AP8puZxaKMMtXwuTZ4hJP34sZZEphdi9Zjxm+/Mp+OOxcREehtCCqhGGuy1nli8/sDthQ7
 aoQzWOoHL5ZpbGHMN/SLiNoUgBhdBSRoZmgD+1JJk9d7k+fOkPqwiHE0BWvftclmj303mH/PUoN
 2BvnsyIvYnasZFwaeKFsyyhJujnG5CgR4qWeDlnraQiHQ9dpiPFRn6D3DgZwjPb7plAU6AHtvog iYvmKmaokbzYFnQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

In an effort to separate intentional arithmetic wrap-around from
unexpected wrap-around, we need to refactor places that depend on this
kind of math. One of the most common code patterns of this is:

	VAR + value < VAR

Notably, this is considered "undefined behavior" for signed and pointer
types, which the kernel works around by using the -fno-strict-overflow
option in the build[1] (which used to just be -fwrapv). Regardless, we
want to get the kernel source to the position where we can meaningfully
instrument arithmetic wrap-around conditions and catch them when they
are unexpected, regardless of whether they are signed[2], unsigned[3],
or pointer[4] types.

Refactor open-coded wrap-around addition test to use add_would_overflow().
This paves the way to enabling the wrap-around sanitizers in the future.

Link: https://git.kernel.org/linus/68df3755e383e6fecf2354a67b08f92f18536594 [1]
Link: https://github.com/KSPP/linux/issues/26 [2]
Link: https://github.com/KSPP/linux/issues/27 [3]
Link: https://github.com/KSPP/linux/issues/344 [4]
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index c15ee1df036a..860b774c0c13 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -863,7 +863,7 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
 	int ret;
 
 	/* cross the end of memory ? */
-	if (base + size < base)
+	if (add_would_overflow(base, size))
 		return -EINVAL;
 
 	if (list_empty(rd_regions)) {
-- 
2.34.1

