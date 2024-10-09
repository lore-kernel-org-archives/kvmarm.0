Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8125E201252
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 15:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728489009; cv=none; b=QTAVi8TKHK86KPedMHNCWZBK7J1F9+2/1b2o8m8y1FEOyysRVa6Sa4LqxlNcFSSeUlmME1v+hOmRZMV+t/kg63h7W8t8BpPT3KKjHXjFGd4ovsJsMxMHUEBTZmK2CphQ2NiHwQLu7hn108T+VObDqviO75kh1yBrRuaxcehr+kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728489009; c=relaxed/simple;
	bh=wpp1BhgAAr1F0pJrXcm4U6/ifagqLD98EYbry7T//bg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N2HKvZ0+MOS5CrmWx71uHGL7V9GAVTR6S/CQwHvJnAGMFoIf6MyJZp6idZE6XtLDO9LuKnVY/SH00F1QjSCP2Ua8CUxU3kXX5OQmn16FApKmW4lkn0yAbnzz9gcgsYfIGKnCKdm8kJP3lq3XuJSsW6nK9nr0XSBTWwydic/hX+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E+VMHrMR; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E+VMHrMR"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e0082c1dd0so146324367b3.3
        for <kvmarm@lists.linux.dev>; Wed, 09 Oct 2024 08:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728489005; x=1729093805; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=dEQn+W1SexZcTNgUxAN0PCwUsSeaftCY9kaEGEXOiDc=;
        b=E+VMHrMRNvM3yXko/TmF2zlZBa0hIOoukK5Oyspkx5wdF3VTSzOHjp4xHQQEvuRp6M
         9YFjFz9TNuna1OmX/axvuIC2ljslfZNMICwWUFj9iVe7qQXuVrApfAP5c9IozQaqgAmx
         xU0tCu+MqT4UkIAQ+VHjnvtoNlBbfI5ipvkIJccAC+A3xlSU1IGkdQ8lQvRj7mLwdCW5
         qXRaZuc7cPsSag50gV4jlgZ5eO3N6/vV11bZWokINsXLFWaBeut9YDdGhTsuKeFB/pZz
         pw3x4qu4fSS1y39VTdtIE7oxoyzsKGVBvAn9NR9TSOtmlr8UvtjnCtyYPmO+l2FJrirn
         ySDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728489005; x=1729093805;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dEQn+W1SexZcTNgUxAN0PCwUsSeaftCY9kaEGEXOiDc=;
        b=mvDkRPYDmbOOd/j0eRjOvbifny4kcwEYA5gDhQImd041oVkDiF2+/I3Rdy++GN8x68
         ipqvnv6CMvvDg+TbjzbfTr0LBJi6y7vIB6lhrm9E/+1R4e8yc+7p5sUn+V/5PvS1EamD
         PW7q3wy653VwaN3CD9PkqztEiaPw/9KJ5lXrj0PYcr8C857NN3dcsasLyKU9BG8R8Wz7
         VrYVp9oANHiQiN8VJTN0Y88HbOyW0Fn3bucledjv3CkegjkyoIoxNMiNnH68ef2AhnE9
         06pq6Jac5rrXmdZc9HCX2qklGK2MoYUU/9rGQtnlUmMlj0wYgCNRrjVTi8yYAMesDUr9
         7KDw==
X-Forwarded-Encrypted: i=1; AJvYcCVAA58bfi6vGUgIyvsyUXe5sdnpBg31dfVkQI9DLo9USPAaSkm4qFFfMWUgc4aiJlHLKtpLZco=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxvu5wDasdjTbWjlqkF8c5i97nNH9PgTSYH82b+Q3osLa6jRh6/
	3gb4OKaDUkO3GZJJn5WI7AW98apcEI7FS/zpyPwo4/rWCyiiwYv9uKYxSfOP3gxti5IqLUagtHL
	c5Q==
X-Google-Smtp-Source: AGHT+IFrWalNmEyn72/5CXUVKhi80GHo8XaYDR+iQ/XjxOT9S8VfevqUwXplC0nvvzPPLclQ9b5vmaVf6gI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a0d:cd84:0:b0:6e3:b08:92cb with SMTP id
 00721157ae682-6e321d4062cmr303877b3.0.1728489005619; Wed, 09 Oct 2024
 08:50:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:49:44 -0700
In-Reply-To: <20241009154953.1073471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009154953.1073471-6-seanjc@google.com>
Subject: [PATCH v3 05/14] KVM: selftests: Check for a potential unhandled
 exception iff KVM_RUN succeeded
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't check for an unhandled exception if KVM_RUN failed, e.g. if it
returned errno=EFAULT, as reporting unhandled exceptions is done via a
ucall, i.e. requires KVM_RUN to exit cleanly.  Theoretically, checking
for a ucall on a failed KVM_RUN could get a false positive, e.g. if there
were stale data in vcpu->run from a previous exit.

Reviewed-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index a2b7df5f1d39..6b3161a0990f 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1646,7 +1646,8 @@ int _vcpu_run(struct kvm_vcpu *vcpu)
 		rc = __vcpu_run(vcpu);
 	} while (rc == -1 && errno == EINTR);
 
-	assert_on_unhandled_exception(vcpu);
+	if (!rc)
+		assert_on_unhandled_exception(vcpu);
 
 	return rc;
 }
-- 
2.47.0.rc0.187.ge670bccf7e-goog

