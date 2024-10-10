Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76411FEFCE
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584765; cv=none; b=SIfUFFwybVmuVPc8k5P24K8mnMEOuGeZhk2gwlBlt8GyKUlCBZK54fYRM3a5vptehu4iybb5czCcjNX5reO+cpaXTRGP0Uv1Z+7+PkiT2h3EIXSpw9TLZ+cwaXc7intw6dYhCUDALnrQrlRX4v6dSKGQQ70js7DHF+s35m8Q49U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584765; c=relaxed/simple;
	bh=+qwur9UMvfPsT7xhW5+1hFXGI3F0T2CjnbFVAQFEZ9U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kldnrMEKnFjoUMApShCLwQU7TjEipFWpODG7YUdSr98LAzTp4P+JLpsF7rVLfGTYLc3MRCLfLBqOi1XZZxoSkXXL2UiKPd0hO4dtsGsLztX7b8dcPMY0Dype9O084c+BkOxNNpcj48+hrvYgLxiA7nQKc3NlEValOVxAOSV+YNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oj4qyC6g; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oj4qyC6g"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71e00c8adf9so1318779b3a.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584763; x=1729189563; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w3u38MFKj4Hgu0NiviVwRjtFpk/ioMNBGBDQlt4DAgY=;
        b=oj4qyC6gcnXuGWFr09zEptf9NnuHzy0JOo5I13afpiIUhHnSns3x2OkElPZXEIg0vs
         V/P04yKOGBqOq9lla6gTmLr7OQIzm1SLCiN8OW6wZ6Q4mL8y9iRE2ZqYNZ4BwaDWiceT
         iLbY8fGyrgxlsD6zdaFkLSL7o10AYnpq3QuGkvH+AaISSpPbYXq9owHcxor8Gpo1fUep
         dttQElsJcx4R6wX9KIDaGW9Ai2vDYjZ8l4Ekx92VeGbXvyp7SEdj2b6ZRbBTpgoyodwq
         HhggeAQcy/lLUNb38/8Rv3/kctZ7xoIDI7hhtgGPIBc3x0Vmz/p1ojWP2pjxRS2JLbev
         JF4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584763; x=1729189563;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=w3u38MFKj4Hgu0NiviVwRjtFpk/ioMNBGBDQlt4DAgY=;
        b=kn8TNPNBq9FuGh6IyZs4xHkGkWybqlJseuoFGS4E96wOMDJIeFaNNZzrroRQPcJ8FU
         Y0DuWKs71pMGLSnIVOvG2M+RAIy3+5ZS9a4mMin+gbglDcSYlTywz1BYkz0YG3YpHhzt
         y2fgIr2zFzcssmJ2ZBi4bPyCYwZpcX5tltpMCZriL88qWfh4xOxCQV8cqJXZhci13j+o
         XpckIPO01LXVLLsIWyJumBJrvsqzbr866IWoeoZCHdzTg+YnJMj09SfZMJa2rNd39oac
         yKjWdcHfDDpli57thULSSdIX7Vwl6pRsfm3SLCzj0sfSh7lmknx1MCJc/H7/t6v2x94E
         dtTg==
X-Forwarded-Encrypted: i=1; AJvYcCUrsw2H0o8PuFlSSvdMGBa7blCC9kKK7ictTGmlYt6m50l9TfJtOmDeaox72kS4mpoYdGDFaDQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwQI955Upqpl9bspDnl/j8tY7qBcJ3MrVqmJL0731AnIaKd10Xf
	wZ22g0R9mYys3hB1w6frivp4HZf/a2xyOBIOmWPZI4ujahLeB5ExKD0k/H3dFBM5MUd2l+rvOHR
	mqw==
X-Google-Smtp-Source: AGHT+IHthU1bxxWE76UmRU/cmSB/2b+tJYVulTyd1SGmZGLYBHQFEbukUNmDJAlwNs2CFth+SfvGFADhDCI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2f51:b0:71e:dd:8f9b with SMTP id
 d2e1a72fcca58-71e1dbe8750mr6976b3a.5.1728584762866; Thu, 10 Oct 2024 11:26:02
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:36 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-35-seanjc@google.com>
Subject: [PATCH v13 34/85] KVM: Get writable mapping for __kvm_vcpu_map() only
 when necessary
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

When creating a memory map for read, don't request a writable pfn from the
primary MMU.  While creating read-only mappings can be theoretically slower=
,
as they don't play nice with fast GUP due to the need to break CoW before
mapping the underlying PFN, practically speaking, creating a mapping isn't
a super hot path, and getting a writable mapping for reading is weird and
confusing.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 080740f65061..b845e9252633 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3122,7 +3122,7 @@ int __kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, =
struct kvm_host_map *map,
 	struct kvm_follow_pfn kfp =3D {
 		.slot =3D gfn_to_memslot(vcpu->kvm, gfn),
 		.gfn =3D gfn,
-		.flags =3D FOLL_WRITE,
+		.flags =3D writable ? FOLL_WRITE : 0,
 		.refcounted_page =3D &map->pinned_page,
 		.pin =3D true,
 	};
--=20
2.47.0.rc1.288.g06298d1525-goog

