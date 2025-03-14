Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45FF202964
	for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 15:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741967480; cv=none; b=tXkzWyJTgW040iuPMGnoJ4UC7rIxr6eiendk7sCVlJNn2QI5aN0wXYVlv+kEiCoMVJNTskeU596tqWFnZ77jzlEYU8iY7BnXeziLQXvH/FUMLPtQZn9qAMLfG9IoX1ZHp4fweHBi1IrYCG8lbHZQUstDXseW2DZKaoknBlVeSSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741967480; c=relaxed/simple;
	bh=T9x3c3QuJ2C9hpuOVam04QMDNACk2y6/xzXy91lyRNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYvjnjH4XkufMxVHnOEcLNxvqmDN3lRY5pmUEXQhpzAgB4+iV/MPH11wMFAcA4MOrRNBckQc0tZIRZzs89dNEi6QcXmF1gX7F48uXlqzRUhDjrM0yAnsY3xIFP/FiHJFzB2+cuwXrx8LA/XHPO5ypBsjpG1hEYYXPLo/CB2VL34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QR3kSYiC; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QR3kSYiC"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4394036c0efso15274635e9.2
        for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 08:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741967476; x=1742572276; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x6KdM0HrFbl7EBCoEX5NDExMeE7MkqEbvD9eQdkyg/A=;
        b=QR3kSYiCvb6s+n658mureIlmTS+4HPJ7mZnlweRwlv25ScAsZWMwIcGYuqIgWr9IlX
         caNwIiuO3YDKYp0Fhdb9d15y3tLCyEwZIgOX3HOl+WkIqQpAJRFKq89TjZN/vXKGzJm7
         kP9dPZej0n+C1hN4T+uuTs+7s4IankplVKwFobc+5sSvTgans2SoS3RWmQE7wrLHebEn
         4XnIP3ehC6XMqr6/AAeoMUmrOItlQLlb2gZFj3mcsokbXCcWXUPamOdV/awr391YTxIO
         wg/16G18mSNMbd3a+KcQUIbKhZAKtvg8ccbWck1+uuy+gU4/FGZMaeaHKnWHNqPNIA2Y
         fflA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741967476; x=1742572276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x6KdM0HrFbl7EBCoEX5NDExMeE7MkqEbvD9eQdkyg/A=;
        b=u6Z14ErI7fnoN0zaJqu09UT5mr1MhvD3oVkYry66BEbpWeMQD6Zr4JNs1GUkddezlS
         n32LYZDfQXlWcdESbl7fShyRO8mjMLzPo6pG+LSgCOY8dsI0OoUdwtz+FQOVYeZKw4co
         eTqwzpL4M3TB3mp2OaDnFhdWG8MEDKG7vwE/HP201LVAqg/3a5RS+SBWz1wabwONBw8I
         hl/hrn+wNn0BMKXcXG79/BB8RLxtsmFjfk1V99ImIqfn3WfBSofs/iq5WfTCrQXeSkmW
         oumA8KBBSZSXfQZ6zXSH5JcyulowvZQYRM8ZIwoKLYHfJjkNKEyeMyZ7qfhTgHzP/1OQ
         VnOA==
X-Forwarded-Encrypted: i=1; AJvYcCXchFyUQDrjDA5Uc1DfELEslLALmR3pQFyyYNdDh17xOQfCmStEkZa/lDW+5wfnmeB4HwhxChQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxILojhC9ccG3ilO+fp+w4uqZuPJBa4U9CYK89UWXQAXkX812O0
	qplDT679hCSvvVtnAcxLORfeN/gcxmxR9Kq6gusD/YhL7FcnVTCOWrmEf6c1PAs=
X-Gm-Gg: ASbGncvteugLVEWsyABNdoCYNloJ2KZOD4P2k3DwIrBJ1GeaZhIWJMgWUd9dMcjPPLe
	A7ZPpS7NwYTg7ecqW9GBYDsY8VaA8kPUa3HZjQIwxbHdP4ICs1VrlLWba/sE7veIzqY4NOHamJt
	82pq2X/nF4z3WPFYtSeLSsB27sbF7nwSA28xv1LPTOBWJAwjT7d86RV0tSPcjOs6dj7A/fMOhd/
	zfZLYpq4Ksg5Ftbkc1EWw6/bF+JgcoIS+JnWvMVkuCGGr/PmHaeXkkrdK03pB3F3o3KqZC81hCg
	Hy5ea3LmxajwZf+HcDkY5oMAs8EvxFXp0o4bgYL4nZRbhPoGv9dEQ+DtVmRAVnvGDDf5f+q7yg=
	=
X-Google-Smtp-Source: AGHT+IGqjIk/FKjEZDkdrc3AqaWCRNKHzrwFDig+752nD7yLPvk8XeA3buiKLcR8gQHXba5VpmxCpA==
X-Received: by 2002:a05:600c:3b10:b0:43d:ed:acd5 with SMTP id 5b1f17b1804b1-43d1ec78437mr43895775e9.10.1741967475876;
        Fri, 14 Mar 2025 08:51:15 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d21d67819sm15249945e9.21.2025.03.14.08.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 08:51:15 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com
Subject: [kvm-unit-tests PATCH v2 2/5] configure: arm/arm64: Display the correct default processor
Date: Fri, 14 Mar 2025 15:49:02 +0000
Message-ID: <20250314154904.3946484-4-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250314154904.3946484-2-jean-philippe@linaro.org>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
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
---
 configure | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/configure b/configure
index dc3413fc..5306bad3 100755
--- a/configure
+++ b/configure
@@ -5,6 +5,24 @@ if [ -z "${BASH_VERSINFO[0]}" ] || [ "${BASH_VERSINFO[0]}" -lt 4 ] ; then
     exit 1
 fi
 
+function get_default_processor()
+{
+    local arch="$1"
+
+    case "$arch" in
+    "arm")
+        default_processor="cortex-a15"
+        ;;
+    "arm64")
+        default_processor="cortex-a57"
+        ;;
+    *)
+        default_processor=$arch
+    esac
+
+    echo "$default_processor"
+}
+
 srcdir=$(cd "$(dirname "$0")"; pwd)
 prefix=/usr/local
 cc=gcc
@@ -43,13 +61,14 @@ else
 fi
 
 usage() {
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
@@ -319,13 +338,8 @@ if [ "$earlycon" ]; then
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
2.48.1

