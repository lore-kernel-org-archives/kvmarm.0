Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E301A1B9B2A
	for <kvmarm@lists.linux.dev>; Mon,  9 Sep 2024 12:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725886058; cv=none; b=Mb3lSTQGGVARxdc8ThwWg2HQUh4UFHcNMfs0IUTHxJ6p4wm+ju/GsceoKiW+iOE40VoRR0cDFc4VB3QDvDeU7jS0JSBmoY1ixhjNq1yE+7sx4YW4VkDaL7Y/Dyf09h94iDoc3MYhOLXtulvW/XN0XEp7y9V2rlWkOZpL8eUDoWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725886058; c=relaxed/simple;
	bh=zuE6bjdcg3jxewdqHSkBJadxfnaCAk197XNJPJ4G1wA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GKmOR/2032UevRC0sZvcMgL4mYAl+3ov7nX16RG7mSvQbNQHJhutTliHDUdjtQFyYr0REoCIiAmewjnEBr5oE+ReLzp+2I+8CBUb634xSDQvoiQtm5JEZNxSK5xa6c5DhwI4vPi0WSIzVn8dD+BXUENmMpHNq/Iu7vMaQyS+CIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CRUgdm53; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CRUgdm53"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-42cb6ed7f9dso8854465e9.3
        for <kvmarm@lists.linux.dev>; Mon, 09 Sep 2024 05:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725886054; x=1726490854; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8qvkXCdHWEWBsZylsWm6hwfThTp5oWOCgEDtNeKXpl8=;
        b=CRUgdm53u1uGpzFv4KCA/xvwKPWQcO6WjhxFuoG8HIWiNXvW+RO8kjKL9pPeo5vJnM
         r045kVoLxjWdfo9kwmvvB0Md205Y4zQg73HS1eq7mcSzMPiwwYQjn82cH/n1rxGWxcEl
         1n5TD1SZIlgRK4VPU2dUWg6ZyzQsK8gOBhVGJxlSWde1ohS8uLo4yaFP8s7nOXIpqKxC
         FpzaWAkyINbfJCd6Ne+ttptg4ngEm342ntrBKrqQ1SpFMy0Ao5qddR8XJ6+C5cCvgN2r
         +9JKcj43kPUgnCQXvhXkWbENHXu8yqhFAkuGQlMwKmG8V0IHdf4EGgUtBmGSkTQ9q9of
         R8YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725886054; x=1726490854;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8qvkXCdHWEWBsZylsWm6hwfThTp5oWOCgEDtNeKXpl8=;
        b=lAAVtlFlebhwiVVxA67bw4a3z6ZYy0fpiP2wyLATE2yYApMe79gTJv/3SncSE8Raee
         xPkmLWlw7DyJeb+pjWu2yJLdYsAyzDZuzXn/VWwcz0unYx6AmWqKJNkY6CwwzreLZIgG
         4+a6pXKD2ooRRN/tflQ0se8WRjGjIeS6nEe4r5w1icVIjYlWoXSJQYBWmFg4spBUW3E+
         1OEnsKDHWa0jMB5x4+U/0TPKUfYm4LfQb/NLEzZQVLVkbIU/FJytfH++wNW9DJZcZl8Z
         IMfbYJgdCwPrPmM6M9GGypNdPe43Olispi4dxuuiL/0kbDRUC38T5qcZmFgyKFrdatN6
         OLTg==
X-Gm-Message-State: AOJu0YwVe/zAJJfGvqkt9FOn5OX0xQCKVMH9mAyseqOM6D6udg8BaSLe
	8YlB0bJnxBOD1qFrcoHazRHydPaXDWPicW8xmjv3dBGmfWSRqwbdR3THQP9+XOU+4ODFofgR3vU
	r2sR4HBO0xBxrup5jdTsxMvX8zw==
X-Google-Smtp-Source: AGHT+IHXNUAE7VdC5OTZOKpQ5J1caGnUk0ojDWhw1KiR9y5AZtlPfQlw2THkS+FmwEps5TC/2oefb8PtdRKpmxLL8Qc=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:68:fe9:ac10:f1b7])
 (user=sebastianene job=sendgmr) by 2002:adf:f4d0:0:b0:374:badb:3cc0 with SMTP
 id ffacd0b85a97d-3788969b893mr13963f8f.9.1725886054280; Mon, 09 Sep 2024
 05:47:34 -0700 (PDT)
Date: Mon,  9 Sep 2024 12:47:20 +0000
In-Reply-To: <20240909124721.1672199-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240909124721.1672199-1-sebastianene@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240909124721.1672199-5-sebastianene@google.com>
Subject: [PATCH v10 4/5] arm64: ptdump: Don't override the level when
 operating on the stage-2 tables
From: Sebastian Ene <sebastianene@google.com>
To: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com, 
	ardb@kernel.org, catalin.marinas@arm.com, christophe.leroy@csgroup.eu, 
	james.morse@arm.com, vdonnefort@google.com, mark.rutland@arm.com, 
	maz@kernel.org, oliver.upton@linux.dev, rananta@google.com, 
	ryan.roberts@arm.com, sebastianene@google.com, shahuang@redhat.com, 
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

Ptdump uses the init_mm structure directly to dump the kernel
pagetables. When ptdump is called on the stage-2 pagetables, this mm
argument is not used. Prevent the level from being overwritten by
checking the argument against NULL.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/mm/ptdump.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index ca53ef274a8b..264c5f9b97d8 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -197,8 +197,8 @@ void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
 	u64 prot = 0;
 
 	/* check if the current level has been folded dynamically */
-	if ((level == 1 && mm_p4d_folded(st->mm)) ||
-	    (level == 2 && mm_pud_folded(st->mm)))
+	if (st->mm && ((level == 1 && mm_p4d_folded(st->mm)) ||
+	    (level == 2 && mm_pud_folded(st->mm))))
 		level = 0;
 
 	if (level >= 0)
-- 
2.46.0.469.g59c65b2a67-goog

