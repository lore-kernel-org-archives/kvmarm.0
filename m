Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4B025B67C
	for <kvmarm@lists.linux.dev>; Tue, 25 Mar 2025 16:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742918878; cv=none; b=WHh2ED8hhapyKHe7gp+Mdx/B7N2t/UdEDwZrUoquGw35BOUf19+30NMrJduRLtM1/0Ci0BGGdKcsgKL77ykyyz9AkLFvFutk2AdkY980r7cahtY+CgTM2DIrM6duXIfnlEyZiNHDh2dUcpdvawcWUjD4IWvMbUOMe+iX45sz43s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742918878; c=relaxed/simple;
	bh=0WONtvv0Wmjtmqi4fbLAdYH6E3j310jc4o7aK+McS3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5/Ig/HZ2TYyxXZg+R5jQa9pkPWLRHsZXnWB+uibZFAUgGGewwJPLKKP3suhRNLi0oa9zxggXtwzldlC7WA4op5Aox/spoe/dJf6FOpUARLBenTABhaE4MDRMMQS27UQiAX9QHueeG0VmV9dtOE/N2A256eQoS7+9LIgFF8YaDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SxA9lAt/; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SxA9lAt/"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43cfa7e7f54so35651415e9.1
        for <kvmarm@lists.linux.dev>; Tue, 25 Mar 2025 09:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742918872; x=1743523672; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S/KkYF0WM2eQ4j8En4HnzFELDHrNfXIe/+MMpGwXHj0=;
        b=SxA9lAt/J9K0pa0w4dMMHfAEpRDapiQ90u3o0+6xKmGf8rBDY4QlP5iZNvMYUWdNcN
         JryT8j8XOvCu1PedyFnZUanGn9CTB9rl5kSnm+rb6wTwFb9XOUGE1AkaFKPYztNofgRC
         uWHZ4yFH7VllXCBh2o+Xah763s9tm4s4NRm3JNZWhyJZmHnnm92/E/lFHx5Vw9Y/c4rd
         Okd5Orj1LzDytqJ8hur4MNOKM0fLdVXylCtsjPtZcNwgKeO0iynIgxeRHlHzlDp4BmVw
         mxrgaYQCyrT9ukR8JAxniZ/cp902toytBD1f3UV0/hXUgDdjNptmgdhsIWj5iAOIsG/0
         hO9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742918872; x=1743523672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S/KkYF0WM2eQ4j8En4HnzFELDHrNfXIe/+MMpGwXHj0=;
        b=mkgXcI+LLYuFUqSNwdMIKHGW+t05lax6XHx4B0q1qG2U/EvV+RdSV5NZ3vrPIhywAz
         aw7/5OYQoxOFheC4Ae2ymtZY+nY45Sy6gkhLCUSS6aeFB4fe1bR5CS/uusv3PGginpha
         C12uE4+1RTfSx8eRWSNWnDh4YQG8rx+L+tYyNfnqMPQX1K0LIcrpc4RFZDbKrqYH7t8q
         kbsGgfShGLsUUbhkq82FY2SjityhqGXmxv6ZtW43Nkv519HaV6vL8IYFKhh/0z3zzQSa
         KH7nqR2mnVlcTYmtfBkjRNDK6Cpe5AY5jv62iVcnHwgeA6pm4vXjwqPzgJ7b9dTJq6XL
         fGMg==
X-Forwarded-Encrypted: i=1; AJvYcCVW4pjQ9AtPEqfJM8zZm8nDf0/MI3EzpNg0xlAlJodaYJVDzpvdT+VMqMeQIkxHAhqp8s5kQ14=@lists.linux.dev
X-Gm-Message-State: AOJu0YzlHQZ1IwRj/DsPlryNhO6brFGHYlsUL0cXISqoFPsVoAEthYt1
	gGnYp+G5utYWJF8k6i8/JNAzhIkiQfqbl6bvHYJ6FvV9KGPEs8Aen/3B1K2z2Rw=
X-Gm-Gg: ASbGnctiXZQncGoxbV8Xrjlgxuo8uH4bH1wIZGTDzj2xuHsZGhEDqWoLdjG3oE1rqKw
	rxUaovd6Trq42oaNxNRenx58eVF9MTg2SZVzem6Ynh/bmU8aedHemz0XgjPBzAieoss9A3F5Qll
	5cmAi6IremXuz7GMHl8nAlLbFlN9zr32F3DWE2V3UiVOW4dpYJkoefHUR61ElmEmBBf3fHKLCi8
	gLGuMV6L25s5+gB4t8hZQQgnoERCLgtuyX334BnJzB3ONFemMkBGAfncwwAChGqhWXYzZr6I1El
	viX8asqUXcMa0DcjqWpzEoK4jv0LmS2BfYoGSM4uUJNrjWBwGwEj7vHcHUDsio8=
X-Google-Smtp-Source: AGHT+IFq4u+jQ8viBriHlPpSVQQmxgDxEvO7i8h+fg3MJkOMdTrOtVoXDilCPLi/MpwsyJ14xZjz8g==
X-Received: by 2002:a05:600c:c0e:b0:43d:1bf6:15e1 with SMTP id 5b1f17b1804b1-43d77547eb1mr3370805e9.1.1742918872581;
        Tue, 25 Mar 2025 09:07:52 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d43f43cbasm203972195e9.9.2025.03.25.09.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 09:07:52 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v3 5/5] arm64: Use -cpu max as the default for TCG
Date: Tue, 25 Mar 2025 16:00:33 +0000
Message-ID: <20250325160031.2390504-8-jean-philippe@linaro.org>
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

In order to test all the latest features, default to "max" as the QEMU
CPU type on arm64. Leave the default 32-bit CPU as cortex-a15, because
that allows running the 32-bit tests with both qemu-system-arm, and with
qemu-system-aarch64 whose default "max" CPU doesn't boot in 32-bit mode.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 configure | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure b/configure
index b79145a5..b86ccc0c 100755
--- a/configure
+++ b/configure
@@ -33,7 +33,7 @@ function get_default_qemu_cpu()
         echo "cortex-a15"
         ;;
     "arm64")
-        echo "cortex-a57"
+        echo "max"
         ;;
     esac
 }
-- 
2.49.0

