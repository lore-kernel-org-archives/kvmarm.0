Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D7E288D6
	for <kvmarm@lists.linux.dev>; Tue,  8 Apr 2025 13:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744118466; cv=none; b=tryoUqaL6x43gujpAkLp3qq16jwjFG5gyduRq4s6qbQBYK5Q/8YsZY6Bz5aYk09kcgctdZSxnm7OGSK6+qNoanYKAqgwwzu9XbYADYrZqlRXnqgm99yoGUu6VdYhkSkNrsQkjKEgjWnw7Z1nPY8PFOulNmLgtwHa8mOH7evd+v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744118466; c=relaxed/simple;
	bh=OSfxs5iCrFQRqvReCu5va442baMyJ2MCQdEE5yR8Qso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BizaZ+Muo3g0fe+LkWqts1A4W1AKuzHlrzJRXfRa/IxwYdYIEyDxTKJlzPyyVDtbEW8iurGW608D1lpVOEbiOe9t8Tbv0/7AmjTSCWykmuNkEFUxnx5WyR32q6ZTVHf3OMJlzfiqXejftUJW0JAnCzxY6ld/ZxFoQm+lXKRSZoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=njEB1548; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="njEB1548"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-39c13fa05ebso3210525f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 08 Apr 2025 06:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744118463; x=1744723263; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ilwSm1opvpysUjixabDWM8lrwnBUd7ZKRR02fY60WCw=;
        b=njEB1548oU+moDqNQXDSjL0pwMnt/x4QnjEo6rkOBehPNdhJ5yuJbb2BAcDVF+HUhG
         av0dehGzIK0SVO6t0xUG2GKUYgRizG/3LVdRArsft20Xsule8He0DRjX8yRK4quGWod9
         Bf4lpJ68melExRBp82Ly/8fvgiiMS38hYagpOCmxRx3KCTplRRqm5gbyO4SDqqVyBpe8
         7kLVI3Ay4kOuiaMzyhLU7HxjeizeM840EyDLkGBxQqM3p5usPfzMFqHefct9nCQxqbct
         YYjUOQ9dnjgvsXT32SsawjnM0M0ZqHWYdjvmvtgdM1RtXB/EB7Nt6nQrtyY1qnCZR3YM
         4rww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744118463; x=1744723263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ilwSm1opvpysUjixabDWM8lrwnBUd7ZKRR02fY60WCw=;
        b=tqm/j+UvHzYiTzKW6eaBPnSgEiin6W58tA4J2dVGyfoc3CqMjpGymBqqghkBUDntfA
         s7hYerX9zmTZcx2YGD59ddAVUipjjiZ2oBxvnbDvRDP4WygRPEueCsbHN1C/3A7oMAsY
         xgKwQn3d00HJqzoLbidUHLKbfVan3iv9aMpxam29RSVXUvFrNq9Q9R5M5j15hdVS3c7L
         xpl7ugnDLIM8imVfzDkbl9XbuqdgLxNk5edBKpNOIGTQ55FPitN8MMF9cPvEcntfKAsO
         NlDCM+Wt+LA3YIVOvwn2xo3EzZvKGttYahx2x6mFoAjztrxcdEyPicq+qx8aJqEObROj
         GUCg==
X-Forwarded-Encrypted: i=1; AJvYcCUgRZVtntUoVqfEuZtgJcQKPwOASmrFxdQrYpVoJXdm405AaoyKoZwBjoKgz7/OnrFRlD1eJZ0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyoBVNIf33FGNbBsYRS4zQbLg3BhBw1mG8/Z5FjSvrtsvOJQpKT
	1JCPz2zz8Ij76dLA6Ppup/BnKJ4QFBBiU+g0gpLANySnHhBi3SpH04Uj/2Pc4z8=
X-Gm-Gg: ASbGncsrgmCjbUHdUvhvReDG03gdL7MUzpLAIYQSO4R1PujlmVzm3FmuzvdpPRHbP8a
	AG7u/tNZ2xs2nkCn47Q5dd4t460Gi2ENZBaNulHJs0N6HseSMlxIijedvAUGhLVwQ7Fp8cW8zWb
	6tAOYeITMHF1cEr7kPopcaqLa4NPchUeNhcGgPFoY0zmHAxJB3vnaaTh2GY+7IUeIjT+iLCAgBr
	o6GIZ6qERxZLjMf9yDcpK4BXiMAvnwBB23V3r7TCDrvl99877fDDv4NSn0Ldlp+snKv/d6r6pRm
	48ucXZXXapzlDUjcQGwWOhFM+SzvpdPOX6lHW/Z7MD4hk2Q9QR84AyGKu3Dd3Ug=
X-Google-Smtp-Source: AGHT+IFNyeSMXRQkAbHJWisVmPMP4/fHS+R5uIOxb+upWzY4DBBeBmZDM0lxIP3xSXgDasJ13TRs/Q==
X-Received: by 2002:a05:6000:4203:b0:391:3998:2660 with SMTP id ffacd0b85a97d-39cb35759c8mr13486863f8f.7.1744118463310;
        Tue, 08 Apr 2025 06:21:03 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec36699e0sm162159705e9.35.2025.04.08.06.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 06:21:02 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v4 2/5] configure: arm/arm64: Display the correct default processor
Date: Tue,  8 Apr 2025 14:20:51 +0100
Message-ID: <20250408132053.2397018-4-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408132053.2397018-2-jean-philippe@linaro.org>
References: <20250408132053.2397018-2-jean-philippe@linaro.org>
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
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
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

