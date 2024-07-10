Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883B2156F2E
	for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 23:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654961; cv=none; b=O5iSmDWsTcpjklJHPGT1XrmzaHvQoaD/i6+98HxxftZorBl65MnXlL0X+d7HOJ4zlllJWwVGdH5wsebTBKfedmIEN+qJ9k86jDICE083hsrrWp2+ro5jY5AsiZjh36ckNxkv8B5Ut6oPo7+te8NDIR5343zDJIjuWz9rjnDTmWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654961; c=relaxed/simple;
	bh=xxkhVIBeGXY8pX54WQHQVUoU/lEQy1GRiLeaV2vAb5k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XeYlo7Tdfr88uYNlqz+1P5dsLhw8xBaNRh40tCMNolkvmakTV5Ye3tDxxT1JZwKenfmP7NpvWtRAQHksCzbKoX6HIysFZpq2HeSI/vpGQUvzaYoM603sf8PWlMbqhKO9o9E504e7jqT5JojoukCy2VIApb6Cagi3SaHHQc5IxEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aMjMUGfG; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aMjMUGfG"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-652c6e92147so5070177b3.3
        for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 16:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654958; x=1721259758; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/kOa+bY4z73FQuKac3t3a5fniJTGUgyq//kzfHQQRXg=;
        b=aMjMUGfGeeOKdMZ324oEZI/54gyeDbuj+2IpsOrBGUzKhSzuenTOowvwi2eVJkGFNm
         HbtK1UbDv9RbvK4bsla1ZrDWpwuHo6wGOODB6OmQJQ2t83KHKUNQowkgQ4M6NOPXkrQh
         xyJyrNvf7PWNaDydloZtXK7ap/o5mWsgg17CFDCPJg980zker5h+pmforJxd32b63Pje
         S/FUzbe00w2wdGdfnaLTcoyjZEWXs327DglbevPZLRpaxiTopFT2eooUafLxR0ZFBH8U
         q3H6XNIFX1oJgeNN/1muBf8e1swrVn/qjY4Y/RpwruxsijtoSR1lmVcpv7nXOhRCt/gQ
         nUjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654958; x=1721259758;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/kOa+bY4z73FQuKac3t3a5fniJTGUgyq//kzfHQQRXg=;
        b=L/IrrwTNoyYpr/K1bKEw5iheuR3YKmYkJBNpElPmmwpk74SA+/+0sKtcFN6SwjtxPH
         XLd0hE18PvgYXbo/EHzC58vzHejQUHe4bcXxa/1TIfEl0EOKMkn7rQsNEr9J4ZxMgIyK
         KR+g4BCqc1Ro8aLcRKQV4BvI5wFLFLLp20cvGviqyvGOIwEoJGRZOLSV9oNSd3w+fj2C
         XMP3twG9JaR3lAyUMd0SCmCFKlhTusJeXwmjDgtL3nuU411p4Nzx9WAkVezV7aCrGFun
         amU4Dtp5hVa199T9/+f5wOU07RaqTnAZqSmfm9HN1MGe5UoyUYnU/Z1pbLksMDVMe1HF
         RfKw==
X-Forwarded-Encrypted: i=1; AJvYcCUhCdCY2Kpi9C7v41GuVWP+rFexPFQE8rJ3kZOdGW4hzY8Kf+7N1Y0g1uPBo6RbsTmpel06vI1zMJjyWdTuZ2wpP1I2e8e1
X-Gm-Message-State: AOJu0Ywz0qLwrcX5dDRKKZrdoTQvfiSvgh7ctPCNENbKd6/p8mXwKJ64
	hyUElG/39OJZsruQsfavGu8VBlbe9euj7wPLD0Fc06iX6+Q7ZFxxOKy4C8V32v2EklHmQqSpNHo
	JAH5e9jPORL358Nj+qQ==
X-Google-Smtp-Source: AGHT+IEQILe/Q46nVYjT6VvqMQTMH6KcT24WPu+37xvorf2J37tSktUkMizR+hLJi1VSG+Olb8BNJuoCHzqVyuyh
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6902:161a:b0:e02:6dcf:e9ab with
 SMTP id 3f1490d57ef6-e041b0688b2mr15353276.6.1720654958570; Wed, 10 Jul 2024
 16:42:38 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:05 +0000
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-2-jthoughton@google.com>
Subject: [RFC PATCH 01/18] KVM: Add KVM_USERFAULT build option
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Peter Xu <peterx@redhat.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Some architectures will not support KVM_USERFAULT, so we need to have a
build option to avoid including it for those architectures.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 virt/kvm/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 754c6c923427..f1b660d593e4 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -117,3 +117,7 @@ config HAVE_KVM_GMEM_PREPARE
 config HAVE_KVM_GMEM_INVALIDATE
        bool
        depends on KVM_PRIVATE_MEM
+
+config KVM_USERFAULT
+	select KVM_GENERIC_MEMORY_ATTRIBUTES
+	bool
-- 
2.45.2.993.g49e7a77208-goog

