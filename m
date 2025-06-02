Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384DC225768
	for <kvmarm@lists.linux.dev>; Mon,  2 Jun 2025 19:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748892542; cv=none; b=jqWv4xYoxRDeojd8c2FqvUeh38BRNOLiG0ZqHkmzJJ/FA6yGE1XOhPSawbqHi9eP01J8gVibJIXxu+dlDaJoqgz1DQi5J4pzLgQGGpuDCo2noEH15xRMhlCmX+ym5Wvz6UAJdH5VQEP1kKYgAsAbbOOJiz2zjrXb3AA5gv41RbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748892542; c=relaxed/simple;
	bh=EE8lwX3DPSHd479fj6h8oG+WY564CeOYM752jwwfbIY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bjNXsXPVlIOnCkVhJpDIYb3c/4nb3MgDFHD3c8d48cxcQ99uB9/gQ/AIwQXzvtHduxXlNGXw5c9sOaQMtJR8v6kpEkt0GGFP2o687aWa6tnzF9VZ24bIZfwdJLVwEpqpQOWPDQxPC4SIis6e9jfZmxtfyPkCFYCGnzLfXP/Yy1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2s08FtbC; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2s08FtbC"
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3dd7587af8dso41696905ab.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Jun 2025 12:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748892539; x=1749497339; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ob4i5lx3NjoopJMkPn2Gu2SflaQcZ8+s5uU/xFdQFYQ=;
        b=2s08FtbCqb7qZn3HiGb5SMjrpkvsNoOWvLeO8LxSl3DMAcSByWpVLLmDExKX4MDSYw
         6yGl1MPGBhOg1IGrXzAoWgl8pT4zvd+cTSFWdnKpuNdv4HRDES5RDs/UZrraMXcHxfg/
         9ZP2L93G2UQDoYNRADh0k2o+dWtdTgFzy+JbwNmV7PzJ3LkkgypGog7wKac3WfPjh8/6
         4YgKeMP+ACMWDC8md7iGHDylkAvvcphTROFEvV3pXxRisfyIhoMlp8DDOI4w8fjRaJBy
         BAxftrK3nIU4L+e0DnRb1BpL6Ot/7mmzV/uzD1RZdemtPBFx3o9KiwYK35TrlUPLtp5A
         WqSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748892539; x=1749497339;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ob4i5lx3NjoopJMkPn2Gu2SflaQcZ8+s5uU/xFdQFYQ=;
        b=Su1enBgw+gw+UvHXKVJXE2pb/1lurLUYgC0oi9ckgj4kilzhj/iAESiXsHRT+21uUK
         WBuUemT8zJO8eD+1iPpQOA40AuInZHJS1CgT+E3qpTy6ktPILwwxHxt/d8fn6fF6jjaW
         SRQlvluWBQ0sSnwv0szauM9G3OOz/ao3CmIE/teQqiOATFyOFYdD4UOCu3ZK+FVBb+iA
         PKEtX6kMNqpA5fvjiQp3JVxgJ4+RRVvEAfqAVCly0EtQM+GmA1BIjyXS9jLGo88S9MfM
         s6Fg59xHvBEibWCymnak1QROmjhM2PdMZncC9JvvAvgaQtQqLpkWP1sQ0Jiq6yPhYX25
         iPUA==
X-Forwarded-Encrypted: i=1; AJvYcCUgjvvCYuxXiY9vvtNO6Wp2KRADw2r6YfepAF63gqVrO1vJUvNQtz78EhSkGXXwoXwRGHAmoAI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+HOJWdfipcwhquIkLmaPrY0aiebVH6fjcTnv8NXQKVJVKlHIx
	jBmAz+CaG3TbulfDGvjrrYsdPS7BUf8cCN4DVn63c1WE8tqpssQp5lMS09yVhuvpdcukDKAVSZu
	QOWx45Cv26PyWHewpPwrgJqKZag==
X-Google-Smtp-Source: AGHT+IG9118tOdExJjBuer/f/VBDO3HNWaiwxBHIeaEYz6xcDfDEYQh0uxIwgejlm2yfIrTUPAC6q6L4NmScHLSSog==
X-Received: from ilbbp25.prod.google.com ([2002:a05:6e02:3499:b0:3dc:756a:e520])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1aa6:b0:3dc:8e8b:42a8 with SMTP id e9e14a558f8ab-3dd99c28963mr156701455ab.16.1748892539395;
 Mon, 02 Jun 2025 12:28:59 -0700 (PDT)
Date: Mon,  2 Jun 2025 19:26:47 +0000
In-Reply-To: <20250602192702.2125115-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250602192702.2125115-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250602192702.2125115-3-coltonlewis@google.com>
Subject: [PATCH 02/17] arm64: Generate sign macro for sysreg Enums
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

There's no reason Enums shouldn't be equivalent to UnsignedEnums and
explicitly specify they are unsigned. This will avoid the annoyance I
had with HPMN0.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/tools/gen-sysreg.awk | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/tools/gen-sysreg.awk b/arch/arm64/tools/gen-sysreg.awk
index f2a1732cb1f6..fa21a632d9b7 100755
--- a/arch/arm64/tools/gen-sysreg.awk
+++ b/arch/arm64/tools/gen-sysreg.awk
@@ -308,6 +308,7 @@ $1 == "Enum" && (block_current() == "Sysreg" || block_current() == "SysregFields
 	parse_bitdef(reg, field, $2)
 
 	define_field(reg, field, msb, lsb)
+	define_field_sign(reg, field, "false")
 
 	next
 }
-- 
2.49.0.1204.g71687c7c1d-goog

