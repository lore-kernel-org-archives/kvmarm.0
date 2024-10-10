Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400F41EBA07
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584722; cv=none; b=qtp5iPJmRT9WH3K5JBznn7m3l+bPrZdaG4Kvqq8mEqE+l8AH8viiOpn43x9tjgV7lXrJR0CZ+1Y6VCTc8V+j3rRb8Vam8cilHTM8kfeL1XSy0so5o7eeCqboGdx/FUvZZcf3MdiSh6WC8tNMrVv5YBILeBYntpxHYdygDfby/9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584722; c=relaxed/simple;
	bh=IF5BVNwy5lfsZS2zGuSAAv+TGmQDGgo7CuXbuO4ZMc4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OgtgR/nEnrelRHzkHRCS+417MJ3QnWBFr6P/dTedOHes1KXBK/zG/58Vyzm1u7DdZzerEy8IlNCmnOpdfKWlrU4fDTXVX5r/RY/vx9+11AJedIxViCl7WsF05hHmU+X32baX65P8E7HZAylKa0dxGIo3IsC4CT+l7hLiPnKqkug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1C4VO/po; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1C4VO/po"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e31e5d1739so25016907b3.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584719; x=1729189519; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F0+KYw/6HzWsmGATvSxbQuKdqCcRS3waqcwxHrAen8Y=;
        b=1C4VO/poe9o3BmSGx8hWap3r+P/AmNqw8K1yppDTiTxsOYFHNh3ztsfCC+So6YKjdd
         MZ7RI5cND8g4lzK9xA1mZzUk1WycVnrpfQ4az2jm476l2wWZyscnlZhACEP6jsgsDjy6
         wKhg5PxLU4Os/YgX2N8X19FDJBPFQcJ4kGjQtNbYyfe2KzxsuNVA79BHJgc5YrZpRiUB
         9mLB4nbfTWXM4L2Gx5fh44YdK07r4sHi41UNjmHaO9EMgXG3WZEPdhtFyzGz9WJDeyCi
         ZgLhtyqdEM/NvS6rnrMTZ4BVy24Id7C3R9KJnNSNBqvGxsgVx5asw8rp1DuSchhGF8lY
         uevg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584719; x=1729189519;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=F0+KYw/6HzWsmGATvSxbQuKdqCcRS3waqcwxHrAen8Y=;
        b=UwhMWbyphXd+l4xSS9rUA8dSUGx6p4JjlhKZD0OfSxNqWt3Ct8cfkwee4ffzMAex/n
         nPmmQT2KGISjXhw/pCfCVlAn4hlV8Wot8ubHZ16uVFIgzXwd7MVOu9xBSx9a/YKbH1O9
         MGh4wHZb7wEhEi3VEtILvYHsCFQ+6uZaNvwDT9wJEqpgq3oJQMBhYPOj2GiTm6D71Ptk
         eQxWGIeAH9MDK6nLNLMf/Ufm32UDOwds3/Wth/JHxhSvTQuKMAWrTXmI11LX+nSz9/wg
         ZxcTvXRo/zeMd/5sX29vFyztl9RawVlhNsEX3uUFmyPwcWg5d8ailoo30pqos0mgBJ1L
         Sysw==
X-Forwarded-Encrypted: i=1; AJvYcCVul2JdEPndh9RLKAd4zPhf1I9Sgta8LJAn1N2t8+A4Rpc888FG69l3rI1Sab2o2yj0cmn1Kf0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwRFVtewMRaOEB5UP78p6soLIKJvdpvPUW/r94JAeILQCWz5wfH
	79y+EDslS6K0dNGIoIgzppqUTLWymMtSpCbbA3uAcuSxurxCULWUGGiizU57DUT+0Uf1o7RSEf1
	iNQ==
X-Google-Smtp-Source: AGHT+IEeBu92qjGJ6/8zutZUBi8WOanw4UupdtztXpUfLE+vAeLHZHNkVuFOksmpHMU427MoGYN+Q9YZlwU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3204:b0:62c:f976:a763 with SMTP id
 00721157ae682-6e322185b22mr897567b3.1.1728584719334; Thu, 10 Oct 2024
 11:25:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:15 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-14-seanjc@google.com>
Subject: [PATCH v13 13/85] KVM: Annotate that all paths in hva_to_pfn() might sleep
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Now that hva_to_pfn() no longer supports being called in atomic context,
move the might_sleep() annotation from hva_to_pfn_slow() to hva_to_pfn().

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0bc077213d3e..17acc75990a5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2804,8 +2804,6 @@ static int hva_to_pfn_slow(unsigned long addr, bool *=
async, bool write_fault,
 	struct page *page;
 	int npages;
=20
-	might_sleep();
-
 	if (writable)
 		*writable =3D write_fault;
=20
@@ -2939,6 +2937,8 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool interru=
ptible, bool *async,
 	kvm_pfn_t pfn;
 	int npages, r;
=20
+	might_sleep();
+
 	if (hva_to_pfn_fast(addr, write_fault, writable, &pfn))
 		return pfn;
=20
--=20
2.47.0.rc1.288.g06298d1525-goog

