Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A09D73196
	for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 20:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710447897; cv=none; b=QS0Ii64r6kZIVwBu8dGpLGLCkqzhGUHNesa6n1MEKxVfskT2718h78rCzHvmdB4yIjFWv6biKCvGfZsxeVCMGcLddLvXUvQWR1c7THm87o7tNuctgopVKQj4t8H8cTCdJL/3w4/gGiOgyKgr7fTIUGcXcIBQ+QtBwEF4cRzJokw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710447897; c=relaxed/simple;
	bh=6/Yu0QDPKynolND3gmbYFuiviBU1OTdPkmZfwvNmj30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YYH0z3l2Ce1ObMJX4dXYnAYRtjvKrmUHIkKs+Ycgh6tgK3CZlmmum8O2m3OeyHvy64c41dBwL/4DVEQnALk5VmSKw30J4uGJSUDWenm4g3NCvHTgCETXW1E7H2hK+1z/WGCWbw1QUt+W6lrJAXPM2QJ9WxmsnHADm2TIzegkd8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gtVZ2TFQ; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gtVZ2TFQ"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2d46e25d6b9so19716521fa.1
        for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 13:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710447894; x=1711052694; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xuCZTiMpeaXF4P5JXeYvn/6B04UPpdx+BA/DKeRB3B0=;
        b=gtVZ2TFQKu3/wO/4bk85MJJYAuixclSdaCRaJo0fLhZOPveoJ4+xfM8YFp5PZj1NNy
         p1AQHfkMnWGDaCYea/CC0vjlqAhr+3GUE/1PLdgz4tFOxjbulaxj8T/fKwLNyfue+mVH
         V3Wkalp7sbaVJIz3c+j4gcpUIgq3aMhZDT5U1f8R/FHG3OHFVoitVO+sAB6Dt5jcCIcf
         JQ3Tp/kCPAUZKKrkn9wvjIYiSQXyB3woruO04RMDoN9Ijsp/DJDhlAFpW/NnX0sRS2Ch
         wlmxl71r0AlzEHXb9lT4knHIBWOxAfEWHTkrrzT62T/4Z4FayGXAGI1vNXxaeb/u1n5x
         g4Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710447894; x=1711052694;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xuCZTiMpeaXF4P5JXeYvn/6B04UPpdx+BA/DKeRB3B0=;
        b=KwvS/ABhCBqMCjGNy7Bb+rAbF5m8YiI8M7fF+8ri/7dd5+m1TejwoBBwOj5G5mImUq
         usg+PfHAk76vqm4SBD242sgIcmCciDGWEf2IirX9l9puOYCCrHO4IB9y5g23fx9MgRti
         p7AvJJtboUWcKNCU1W8rNpKm+pnxqYo2++7XnRTkrdMxK9ynhMKIY8tUNXfYsmMio3+l
         uLbuxqV31kObf3GIsvNIZjhDpA4339iSkAVbXvmpaljjI/qgux18aDQb5kg8rmqj0IXD
         Ivky9u4KUQye1CqpER4uWq+xHV3Zo997+GNJSwoD61/TCYuN8ekDlrRscZnIOwVaHV7y
         PrWg==
X-Gm-Message-State: AOJu0Yz/aPhIOO3hcPagW8RgwaUCFkCFwFJC5N5E683vSG87yhsjOtg1
	jJk1lojiuEPp64jiiV2q+HYMjc+oYz/zl+vc/hHQ0XpM/ujp5qCw+2RRbs2RV2boeNxOhTyl1Ix
	u3fF7
X-Google-Smtp-Source: AGHT+IGdzgal9d7jECsheAve01ljHpLhiGK1mtn9v3Osy56JhBtqA4ZSO+j/CgBHoCEF6ku+b5RVYA==
X-Received: by 2002:ac2:4ed1:0:b0:513:caa7:3773 with SMTP id p17-20020ac24ed1000000b00513caa73773mr867447lfr.63.1710447893822;
        Thu, 14 Mar 2024 13:24:53 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id jy5-20020a170907762500b00a4675490095sm746999ejc.42.2024.03.14.13.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 13:24:53 -0700 (PDT)
Date: Thu, 14 Mar 2024 20:24:49 +0000
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>, 
	David Brazdil <dbrazdil@google.com>
Subject: [PATCH 06/10] KVM: arm64: nVHE: gen-hyprel: Skip R_AARCH64_ABS32
Message-ID: <e017fb72f9aef1de10cb958bfeda87496d3ee9e0.1710446682.git.ptosi@google.com>
References: <cover.1710446682.git.ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1710446682.git.ptosi@google.com>

Ignore R_AARCH64_ABS32 relocations, instead of panicking, when emitting
the relocation table of the hypervisor. The toolchain might produce them
when generating function calls with KCFI, to allow type ID resolution
across compilation units (between the call-site check and the callee's
prefixed u32) at link time. They are therefore not needed in the final
(runtime) relocation table.

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c b/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
index 6bc88a756cb7..7b046d97b301 100644
--- a/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
+++ b/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
@@ -50,6 +50,9 @@
 #ifndef R_AARCH64_ABS64
 #define R_AARCH64_ABS64			257
 #endif
+#ifndef R_AARCH64_ABS32
+#define R_AARCH64_ABS32			258
+#endif
 #ifndef R_AARCH64_PREL64
 #define R_AARCH64_PREL64		260
 #endif
@@ -383,6 +386,9 @@ static void emit_rela_section(Elf64_Shdr *sh_rela)
 		case R_AARCH64_ABS64:
 			emit_rela_abs64(rela, sh_orig_name);
 			break;
+		/* Allow 32-bit absolute relocation, for KCFI type hashes. */
+		case R_AARCH64_ABS32:
+			break;
 		/* Allow position-relative data relocations. */
 		case R_AARCH64_PREL64:
 		case R_AARCH64_PREL32:

-- 
Pierre
