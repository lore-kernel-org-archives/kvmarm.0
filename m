Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F7D34545
	for <kvmarm@lists.linux.dev>; Sat,  6 Apr 2024 12:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407212; cv=none; b=toQIyEF/Yf7x9Rx892lPWwQZYipv+NmznDgEESIkDhBv2Q2oti3WVNKLtxGft3YgxtBvG95N8Opmw7ziND86tWXV0/WMcfd64hyAKyR0A5j0VTuRPm972B5Q9Ki1E2OnXKMdmD4CmQV/bvVX1TjzwpFULvoIr/JAuV/NmTaROJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407212; c=relaxed/simple;
	bh=BtK71PP95PMC4Hzbtxe4zhZtffb72GLFVB/PQAL00a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubG6KI9JruQD0J6ejg8zJeki/pPb/LOX8N1W229HTTGX/JliDsqe1h11X50saOdjwh76F9ipKbWbp3eMstvCfcJhcHB8mm1Mg5pXHLijkCyYZwk95I3lyXKfFiYx4NkyEb6GBp7/F80WWKnkJ25JjAH+93/hSJwI9YEA8ZgSUHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gLQ+POAw; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gLQ+POAw"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5c66b093b86so3113642a12.0
        for <kvmarm@lists.linux.dev>; Sat, 06 Apr 2024 05:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407211; x=1713012011; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+DuXv8jLymFAc3dj84mPa+u6v5joW+GUy7CVoN0Mom8=;
        b=gLQ+POAwBEtvazbDM4WyqzayVaMzOM37UakQv/dUeWz96qhfKwnLeG7gLIE91Hbb7J
         /vsMApAWA+fVcizkUM25Pwml2PM+gth6lHf4yjm6rZVkJ1uAJHRlOKI9XdxZJS6gfhFI
         zX9ycqjPk5tIQPujXBx76YYN8aApfNTuMk69LYlBFF3LWf5eruVVHMry5ZAJ8TtOQeBU
         oGEnaRggiXmwIdeviibDuxSZ1fA3+cspxeghkUaygy3lm3tJPzPcfrfIO85tOkLwOAuf
         qhvcg1E0DDUt+8f63et9TPNC4QYL0Y4/zOnAz6z80nYGeBSYsqcqUCYLJPxzCrciO2ya
         u1RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407211; x=1713012011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+DuXv8jLymFAc3dj84mPa+u6v5joW+GUy7CVoN0Mom8=;
        b=j9aGfMM21tROm/j1oAToR0owFaqYFDWH1QGeO9u2mY7A09mC9Q92WfBmZv6zikw5NG
         8UbRmZtGlWQtJ6lyXIl+CqNuX9QC2afj4nw01/ybrGRlRrz/dtlgVwBEujMtmBDPvK/N
         9SezbV3M1N3XW5PFBnhxRwauSnErSIKIYeZrI62/3VhgHYbyE1VHvlNoS3xe3vKbFPgu
         fSVvp5Uz4xjiC6Ed1bBb2bbFDOvcM+Kba31WAkO0S2OjyHNjSKjkOVHqI8TuKPgvA/aZ
         k6N11TCnXK2VdcgIAYfOwaqPvphFMVWy8wA5rkyvxc0oI2HS+hpSt3UbQH4vmuLoZrRL
         TGCw==
X-Forwarded-Encrypted: i=1; AJvYcCWjm8fIEe25VvE1pc2gUoptMWZvmAnFHGYe+QWgRrdXVPuWaPlxXB6Mp4O7UbCm0sxTuTpMKBhSdDHble48qP3nLteJrIbs
X-Gm-Message-State: AOJu0YxtLNOKLx47R5b3VTjICqa57t9GtBrkQfj4hJ62yjsDWMszVb9h
	313fUZQYvgtWht9dcBzdDm7peK+O0floJHxZjjng00evxCQt5RST
X-Google-Smtp-Source: AGHT+IEG5DwuJ6rWhrJoMat7kd4rj//Ns4BzAmacd0b/2q33I7gOlOkW3W7COJMdw+lJbq3lxrimmg==
X-Received: by 2002:a17:90b:1b04:b0:2a0:4a82:5b05 with SMTP id nu4-20020a17090b1b0400b002a04a825b05mr7263902pjb.19.1712407210832;
        Sat, 06 Apr 2024 05:40:10 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:40:10 -0700 (PDT)
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
Subject: [RFC kvm-unit-tests PATCH v2 09/14] shellcheck: Fix SC2145
Date: Sat,  6 Apr 2024 22:38:18 +1000
Message-ID: <20240406123833.406488-10-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240406123833.406488-1-npiggin@gmail.com>
References: <20240406123833.406488-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

  SC2145 (error): Argument mixes string and array. Use * or separate
  argument.

Shouldn't be a bug, since the preceding string ends with a space and
there aren't any succeeding strings.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arm/efi/run             | 2 +-
 riscv/efi/run           | 2 +-
 scripts/mkstandalone.sh | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arm/efi/run b/arm/efi/run
index f07a6e55c..cf6d34b0b 100755
--- a/arm/efi/run
+++ b/arm/efi/run
@@ -87,7 +87,7 @@ uefi_shell_run()
 if [ "$EFI_DIRECT" = "y" ]; then
 	$TEST_DIR/run \
 		$KERNEL_NAME \
-		-append "$(basename $KERNEL_NAME) ${cmd_args[@]}" \
+		-append "$(basename $KERNEL_NAME) ${cmd_args[*]}" \
 		-bios "$EFI_UEFI" \
 		"${qemu_args[@]}"
 else
diff --git a/riscv/efi/run b/riscv/efi/run
index 982b8b9c4..cce068694 100755
--- a/riscv/efi/run
+++ b/riscv/efi/run
@@ -97,7 +97,7 @@ if [ "$EFI_DIRECT" = "y" ]; then
 	fi
 	$TEST_DIR/run \
 		$KERNEL_NAME \
-		-append "$(basename $KERNEL_NAME) ${cmd_args[@]}" \
+		-append "$(basename $KERNEL_NAME) ${cmd_args[*]}" \
 		-machine pflash0=pflash0 \
 		-blockdev node-name=pflash0,driver=file,read-only=on,filename="$EFI_UEFI" \
 		"${qemu_args[@]}"
diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index 86c7e5498..756647f29 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -76,7 +76,7 @@ generate_test ()
 
 	cat scripts/runtime.bash
 
-	echo "run ${args[@]}"
+	echo "run ${args[*]}"
 }
 
 function mkstandalone()
-- 
2.43.0

