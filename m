Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C9B25A348
	for <kvmarm@lists.linux.dev>; Tue, 25 Mar 2025 16:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742918877; cv=none; b=IPJ7YwcP3QYY/nkIVZZDSq3/L//Z+cWcs5D7JAWTn7rZ7mdj+MxXXjljD4XVoMiyE/plCduhXs2k9WZTOTFp8Mhz381LPnYDhjfvHudHWw0f1KavNvFTLxMKG4cJC2H4YD/iA/1BNxi+gG/YOhKQKtYYtDkRbm0gtazOpPKR57o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742918877; c=relaxed/simple;
	bh=pCZd7GShmFREJQXP8FWM/PwyLDPr3IHAugWyScPUO4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/fzO6ZqOdlJwfZnDNek9PI+/OzKlovLP0o/oe7RavRFOfEd1/aVyIPFqM5mEz2CJsoWyv5f15+l0XkHXCNwOS/n0eJxLG8UwYtPnYjvZzLJcQl2rdG/zOcznJS0bcZX3EMapq4FIWboi0CiOI/9Ja8n4TUfgsZKv8pNDfiyO2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Lprdkhis; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Lprdkhis"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3913d45a148so4720817f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 25 Mar 2025 09:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742918873; x=1743523673; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rb9ebUJ9N7Jt+0/wSlKeZDJqEG8Zo62aWudcvmr0rRI=;
        b=LprdkhiswfHHZPOQYiwBILL0Hm4auUi9dx+d9K3X0Q8tDbHmZY/79HOA+YBhHQ2yC1
         Pf7yIOzyvxaYBDwKPXcZ1o/+KOlLUK3fI1XnKx719CgyM5sIwrzb+dfTcnEI2GsbVYgU
         QuomdHJoh6oJsxS4bUwaET+ESkkNXgQUJ/avPZehx3ZUVE1meHnXWwNz+WnL8vQZbMMK
         vf6Y2BsdN+mIJWIB0eZs60+edQdmbVY48WLkuDo0IaB9tnXUuXXAi4flbjcKle636ZtT
         zsGByPKPs6ipILScEeE07qHFJoXqCdD/ZpUrLCitdIOmWmesRk7MkpxkK6xwdCC0oYCG
         v2sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742918873; x=1743523673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rb9ebUJ9N7Jt+0/wSlKeZDJqEG8Zo62aWudcvmr0rRI=;
        b=wmXp0kp97Geu8zXI9UuT/0lkEzxm4P8u10k2bKhNcGOLjj6+IkzVMO5wpj1Fch/R3C
         buDeCcDyxXmU70ISQhGc8JJ6SsMzA+4Q1xx9SF1Uh46xAb6G57iB9BLsUuHECa6qzcSF
         saCGgP650Jv9v+ymM/UxzHZST5CW+5gIDsCSYG66AuMmURSBQeYjxTy9YHu4TxC6etVK
         BumVdPpZzkuycTWJDETjoai/+D5KoI4JdTEzfoPuuV2IH+K14UrzKkYp/wuXiuPVEKTX
         JWdoGfE/j1R4f8VPU6NlMiBz28FaWRpuD+6yMPOsqJ24e1StB7tFJcd/6svQPLiWqN6B
         bTPg==
X-Forwarded-Encrypted: i=1; AJvYcCWxrfew5XFWwG4jcLGO+cEoaGE84NeO70Kj4ioqfF67eWhpKLgvhBH30ZEVsMrOMh0qznDeXpQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxwRKZ3jrBZGx61NR0ckr+jhw5AeIWC45I9yyxZ3WiLVWxaiJDM
	dv37igGu3mSeCMwNVO+jZgjYNlS9urnEMZlbNhAyuC2HxoZMvROA++HOfheO8Aw=
X-Gm-Gg: ASbGncs98+ClzYeF5e88Y9RNaBbg4O8uOFpcnkxfvsiqGBsSt6YQU98OEVMsYdWCGmY
	5U5mfNJZPprp+7sgQNeCV5qSC2VL40KeSFJX8X5/iLmfE03jhPTE5WHzGCviElszCt7lmCkaoLI
	O0jk58Qa61h/oP5Z6MUqZkyB6DK16iSxUrlJ3DWsBl0ZLG6Tdzq39NvHk72AREELNPrqMO2qMcq
	PIQFTEM06U77YzjK95BSWedr6kp4dSH0phANn9fnc9I4wGZDzNY70ZNOZdTOP48nc1cHIb9W6fD
	k50smzPiFnW87skvzPwj1QI/hbb8ZvINRie9+WWRMQasvG4fj0UtuE22PkcoO9Y=
X-Google-Smtp-Source: AGHT+IFI/7tTmUNqF1LFsp9CSF0jzd2wofLTJjRMMtVmsGu6/uq/OnH6WnDOGAESyJFHG7RUegV3gg==
X-Received: by 2002:a05:6000:2d83:b0:39a:c9ed:8657 with SMTP id ffacd0b85a97d-39ac9ed8663mr1542229f8f.17.1742918870911;
        Tue, 25 Mar 2025 09:07:50 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d43f43cbasm203972195e9.9.2025.03.25.09.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 09:07:50 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v3 2/5] configure: arm/arm64: Display the correct default processor
Date: Tue, 25 Mar 2025 16:00:30 +0000
Message-ID: <20250325160031.2390504-5-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325160031.2390504-3-jean-philippe@linaro.org>
References: <20250325160031.2390504-3-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexandru Elisei <alexandru.elisei@arm.com>

The help text for the --processor option displays the architecture name as
the default processor type. But the default for arm is cortex-a15, and for
arm64 is cortex-a57. Teach configure to display the correct default
processor type for these two architectures.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 configure | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/configure b/configure
index 010c68ff..b4875ef3 100755
--- a/configure
+++ b/configure
@@ -5,6 +5,24 @@ if [ -z "${BASH_VERSINFO[0]}" ] || [ "${BASH_VERSINFO[0]}" -lt 4 ] ; then
     exit 1
 fi
 
+# Return the default CPU type to compile for
+function get_default_processor()
+{
+    local arch="$1"
+
+    case "$arch" in
+    "arm")
+        echo "cortex-a15"
+        ;;
+    "arm64")
+        echo "cortex-a57"
+        ;;
+    *)
+        echo "$arch"
+        ;;
+    esac
+}
+
 srcdir=$(cd "$(dirname "$0")"; pwd)
 prefix=/usr/local
 cc=gcc
@@ -44,13 +62,14 @@ fi
 
 usage() {
     [ "$arch" = "aarch64" ] && arch="arm64"
+    [ -z "$processor" ] && processor=$(get_default_processor $arch)
     cat <<-EOF
 	Usage: $0 [options]
 
 	Options include:
 	    --arch=ARCH            architecture to compile for ($arch). ARCH can be one of:
 	                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
-	    --processor=PROCESSOR  processor to compile for ($arch)
+	    --processor=PROCESSOR  processor to compile for ($processor)
 	    --target=TARGET        target platform that the tests will be running on (qemu or
 	                           kvmtool, default is qemu) (arm/arm64 only)
 	    --cross-prefix=PREFIX  cross compiler prefix
@@ -326,13 +345,8 @@ if [ "$earlycon" ]; then
     fi
 fi
 
-[ -z "$processor" ] && processor="$arch"
-
-if [ "$processor" = "arm64" ]; then
-    processor="cortex-a57"
-elif [ "$processor" = "arm" ]; then
-    processor="cortex-a15"
-fi
+# $arch will have changed when cross-compiling.
+[ -z "$processor" ] && processor=$(get_default_processor $arch)
 
 if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
     testdir=x86
-- 
2.49.0

