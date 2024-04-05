Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0153A15F338
	for <kvmarm@lists.linux.dev>; Fri,  5 Apr 2024 09:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307755; cv=none; b=bFTqraVBJ2+b8UY7TlhZ9kQxe49cSVAU9TIUKtpH7uL+Co4iM1euUzX9BeO9MRFujSafZGwGNfwaZhrop5rmtYj3I7ABQ9UD8BQBWVyMLKUCtjNzL0fH/YdMfONWwVSBnP1eG63wcxUrkfsE38AntsNNQ496vKpkQc8Qyi5qaDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307755; c=relaxed/simple;
	bh=2vv/IKl54+GfCSIelDXCPjWVEwwZrrCpGl2AJlVYet4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMqVm9rzU3J1eZeLF2XWPUSqKno/ECqZ/HI7ZW/nKPv6e8Mol0P1hMfALHEMRnG7bkpK++Cx/wXYcawMiKaXHk9VU95U+dMhq5L2W6ioH+A39BKf7OKUApTPTEHLC3aUGtItivZxMR/LcV1m+b3XwbmhUZhq+Uh3yGoHWR59ii8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eKaRXCUi; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eKaRXCUi"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6e782e955adso1797784b3a.3
        for <kvmarm@lists.linux.dev>; Fri, 05 Apr 2024 02:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307753; x=1712912553; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FQyG6PJPa2DgRXJ6ENxjgOjT0GZyabu8ITbgcsO6HNU=;
        b=eKaRXCUiBYG4hRmi+xdzSJldr9jOj5j80j380f1UUVXAcm+y8ebfsGYWWmKW4dP9Db
         50ZZDkuA4GJ69rfT5T3d1DZJxQkrpEWisWwqrnpd1JdvuhQ6pOh/+aUc7SG1FgtPyB0M
         YWiJ8m62QtxrQtgCBPJuYOq9u8Nim0738YgY/URspjnQIVc+E+nybOoz6oL7U0RjsupI
         fPIJ/ttKHuUTjt1zEbo/RrjZ+cICutdqffJLrLv6NgleykuHe55tQRkBFTSkGswwJjGS
         l+IhPXu4L1J1G1wrcPkU1wqUENbHGkH2zNK70ck3wMDg7A48+4Lp5OqZEo8Fs30dArxf
         1SHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307753; x=1712912553;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FQyG6PJPa2DgRXJ6ENxjgOjT0GZyabu8ITbgcsO6HNU=;
        b=jvctHb9BuF+lM4LZ+Ekl1ziuHPLxujXemCcINSielGFqo18903Gn0MNNmG2cEJNU2b
         695sgqSJSN8T70MqZab5SZBpoTZ+CfapFhcE+M+MCJMy9ND0Uawzj4zW3RcCz/IQypMh
         3maMG/gYSuAojt5uSft8YIy+7bZOFSNHELlN4Byhp4uc4lLggwZJcDQGGosccxVlb5PW
         ycERa7NK9rVm+9qVNrVij6rMhy/mS/J7cWZVeZXM7DxBUT3wGUZWreZ7SRkSnYRCXmAI
         5ig+dK3MNgeQt/8OjmxplgKhAiD6meThi6KEn1d5iKy0IdwOdLqWpFQic20PpSbSJ+BA
         rjXQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9mQ0a+2jr19N7/RPzuRMTZ11xAzMlYXKIdgCQY73/bhUR2ebbEVA/X0jnQWZAbhmsvTJNwdZhe/nACJS/+rHNZCdUYygu
X-Gm-Message-State: AOJu0YzOlT34kYkguerFaP6wg5nvQsMw8ejglMhB2PZQ/ei5FZukNTgq
	949qRS9Gp4RxNzaFBlQ9j4h9VZOtxPVOzm3CPaewKY9VovFgwm2/
X-Google-Smtp-Source: AGHT+IHhBxfSYK+gCHVhFCLwN0vh7vqzr1fhMMMTvd8dOdpq1OMcW1smOYtODZbfkK2Var8DE55FAA==
X-Received: by 2002:a05:6a21:1a5:b0:1a1:87b5:298b with SMTP id le37-20020a056a2101a500b001a187b5298bmr1072821pzb.21.1712307753391;
        Fri, 05 Apr 2024 02:02:33 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:02:33 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Nadav Amit <namit@vmware.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Ricardo Koller <ricarkol@google.com>,
	rminmin <renmm6@chinaunicom.cn>,
	Gavin Shan <gshan@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests RFC PATCH 10/17] shellcheck: Fix SC2013
Date: Fri,  5 Apr 2024 19:00:42 +1000
Message-ID: <20240405090052.375599-11-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405090052.375599-1-npiggin@gmail.com>
References: <20240405090052.375599-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

  SC2013 (info): To read lines rather than words, pipe/redirect to a
  'while read' loop.

Not a bug.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 9dc34a54a..e5750cb98 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -487,7 +487,7 @@ env_file ()
 
 	[ ! -f "$KVM_UNIT_TESTS_ENV_OLD" ] && return
 
-	for line in $(grep -E '^[[:blank:]]*[[:alpha:]_][[:alnum:]_]*=' "$KVM_UNIT_TESTS_ENV_OLD"); do
+	grep -E '^[[:blank:]]*[[:alpha:]_][[:alnum:]_]*=' "$KVM_UNIT_TESTS_ENV_OLD" | while IFS= read -r line ; do
 		var=${line%%=*}
 		if ! grep -q "^$var=" $KVM_UNIT_TESTS_ENV; then
 			eval export "$line"
-- 
2.43.0

