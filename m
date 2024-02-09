Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CBE664CF
	for <kvmarm@lists.linux.dev>; Fri,  9 Feb 2024 09:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707469922; cv=none; b=lDC8Hnxn4dz0kyu818G1Ltzx6gMfL76lfOc8sELzXDr29dbvqpa+reTWNM5oQNpn1TAM7G2aGM6NLnORS/wn3LR5X7OfTmTLobPwWiyG0Kj6yb63RoPl5Vp7ybJVTljt3eYxOIQ6jGPA+08KwVRV5S+/nhLIplUNPfnFOrpjCpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707469922; c=relaxed/simple;
	bh=XkWbXJiup8BsE99nEBZlkdOg//43UMa/HAUJAsLv3zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1xXpLv39uWDHLrutKHXk7wTF5R/H7E2RO93uVRx4gUzRq6/wiIexzisYeurSw7k3gkiGnFRFuU/KI0qiZE3lvkGOJM1s7vfMwAovnWlROQu7FNZQ755GyEYWTo4v8cVl2gh1+EYpUd9W4sHqtrYepfsmLSrzzEdcXFDSZUpoiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aK3GkiNN; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aK3GkiNN"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-363b5bcec8fso2371045ab.2
        for <kvmarm@lists.linux.dev>; Fri, 09 Feb 2024 01:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707469920; x=1708074720; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yS+ul2b/NpaGNmT4nHQYQeP0IrroORjWUgFq1DiJtuk=;
        b=aK3GkiNNsdfdXuQbFGPupWOYKZ4mK28bz9MM9q/7iNCAZ9o3CFbbMdDJljC0AkjMcB
         mf2n/icsmOqg2HzuuoCssFP0+G881ZJTs75auk2ZWYFfjvjpdWDbOa7cGtcGBAF6tinm
         S23RkpboaTA/o4JPNyz8x/T7TESfxA/J0Q13MKU9VCO37cRf4xa5oo+YkPZQua/3iTSP
         goZG63TqZjEgx41urjb9s1hMQBiv7GiBGRIMUVQyX34iSGGdiLP5pJRw8iVujpvj78CF
         QX9N57W3tVPNtjOzUBujLaNXl9Ht9fna881YZ0J5VQTlMbR+fk4KlJhxaUkQvRRwEXQP
         z67A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707469920; x=1708074720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yS+ul2b/NpaGNmT4nHQYQeP0IrroORjWUgFq1DiJtuk=;
        b=OummXKZ1re1NDzdri6fAQ+NvSd3CK6MJMXZiJqasE2ZvMxITh2tstJ34fJze5o1DjX
         WceKMssJo5jj3m8zFtVYqS8bUKqR6DgW81QBTEv4RIZsMcuKCudzBIAEXkEmZl8HCsX8
         I6YCkuh+oMljr2W1I13PHscsyHB6ruJ2z6AZuPM5wG0U+Dvnn5QtqyRT6fEE9pdH780+
         bFI0i4y/sa53qQ0SvMUycLBAxIy9yKqS6Wmy3wAR0M3cz3XAjFsr3k2MkENX4ooMFfn6
         wh/F13fQHlTLgTins+wu3ZTcBmPQuOHolMXdQhwdGfCZLBDaYQiWMy8yjBHvjJ3voU/P
         KjbA==
X-Forwarded-Encrypted: i=1; AJvYcCUXtQfR2to95fZ7T38KBRdWWZBTkVrlacvhaouzvaSvZjgvSoLtSRexDxlWiBT2f8maFGi3SvXH51GprQcCAnl5khUeCoWs
X-Gm-Message-State: AOJu0Yw+ZGTiXr47MDvHsZisSzFwGB9p7nzgLg6OneExS4nnlkqsobCB
	io374esBgxVIA9rsRhd7tfzOHJHVfa17km+QPKNw/8vT7zA/nk7y
X-Google-Smtp-Source: AGHT+IFRG49LrsMALjwaw/QQGV3P6t7iqzINaidenzf+7nkJ/oR5JUoQayo972KhNecT03FbRR4u3A==
X-Received: by 2002:a05:6e02:12a6:b0:363:c5c9:deb4 with SMTP id f6-20020a056e0212a600b00363c5c9deb4mr1134765ilr.14.1707469920181;
        Fri, 09 Feb 2024 01:12:00 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWDopPltMDOD/Zc+PObLBIP1nne3PAHsVM6zRZWO1HpORlibOckT/gTcQ19PG5LdBYjTnCRcjHTqOD87qjEXIJ1Cw7vJKBTxRxvlbtduv1eAO8QEC3zvdE/JG45h1/hySgdnu4sHEuXGV6jdeujTVLoH6eqLOSPODhCWZI/0SPP3ZkdBudUiSkYqEz1CH99b0O99Nhv5N9EuQELW/E6kWEb6PyvGtdAXrgaVAXE/TeAkLARmmyO0zgbKZglUUiiDGXR28i7Prujn5UHTgY96rYxQNCAhONw7ZbmBCGszMHcWZlZ2hqwhT/hzy/4gSW65TNy5kHI8BBZUl11FY31xxTtnsGu5DOcr/0dGsTqplINJ0f00gj+4/Qf/JWNCKfUWmeheIRgqAZM/KeBUcgdkSTFXIItBmlR7IQSTajuDXKUEEqzQJANuFk2VqKEAoJ+hJhIzPltXqVq2CgQBb28tG4SNO6NsoSINmz0faIh18GbVw52Y1je6CsC9xx/zd8vtsYtwnRkF9tDoHCe77ZgebF4irBc+bEu3Iq91jwtK3kjmKiFN6wxQBWX
Received: from wheely.local0.net ([118.208.150.76])
        by smtp.gmail.com with ESMTPSA id cb1-20020a056a02070100b005c1ce3c960bsm1101742pgb.50.2024.02.09.01.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 01:11:59 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH v4 2/8] arch-run: Clean up initrd cleanup
Date: Fri,  9 Feb 2024 19:11:28 +1000
Message-ID: <20240209091134.600228-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240209091134.600228-1-npiggin@gmail.com>
References: <20240209091134.600228-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than put a big script into the trap handler, have it call
a function.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 11d47a85..c1dd67ab 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -269,10 +269,21 @@ search_qemu_binary ()
 	export PATH=$save_path
 }
 
+initrd_cleanup ()
+{
+	rm -f $KVM_UNIT_TESTS_ENV
+	if [ "$KVM_UNIT_TESTS_ENV_OLD" ]; then
+		export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD"
+	else
+		unset KVM_UNIT_TESTS_ENV
+	fi
+	unset KVM_UNIT_TESTS_ENV_OLD
+}
+
 initrd_create ()
 {
 	if [ "$ENVIRON_DEFAULT" = "yes" ]; then
-		trap_exit_push 'rm -f $KVM_UNIT_TESTS_ENV; [ "$KVM_UNIT_TESTS_ENV_OLD" ] && export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD" || unset KVM_UNIT_TESTS_ENV; unset KVM_UNIT_TESTS_ENV_OLD'
+		trap_exit_push 'initrd_cleanup'
 		[ -f "$KVM_UNIT_TESTS_ENV" ] && export KVM_UNIT_TESTS_ENV_OLD="$KVM_UNIT_TESTS_ENV"
 		export KVM_UNIT_TESTS_ENV=$(mktemp)
 		env_params
-- 
2.42.0

