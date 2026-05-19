Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF554409628
	for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 13:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779197136; cv=none; b=YynSSGsBvTgKe8MCQ0YRhn9xATQLgR5EVk4br0QSXFJWUyRU2uQq2lM1IZVIt1HtgygQAwzH+likllkOprXmFPt9qyIHi+S8nU/3roP6LUHuCAJLKrqh/Ob+5usI+B3KMa4cmcAfJFr90mjUbQWu733g2NBm4E0zGvT+3XBns/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779197136; c=relaxed/simple;
	bh=MPMKDbaoJm8lYSmKNZ/S8Jqum0mwmrvQaQMqtJ3cNuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbV6zmJJvds0StksIlYIKrMm4P/MVrMMa60p9uSqm5wlSKShpdVAW8dJsmqZxDo5KbLMuVUxdfnuvHYlYlJ9I3MwL2oe3mvgVJbWBkmrua5LruYBIwZ4SgwaaZA3jK63dc+H5kuiXjEPP7M5Pza419Vv0WW8FT+Vo3rUuBmmFiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=brin6uXJ; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="brin6uXJ"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8b9f2295a9dso41770136d6.3
        for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 06:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779197134; x=1779801934; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yFek1k0mWh/Ty3927Ox1UTfk318qie1Wk1ylGq+Jroc=;
        b=brin6uXJPPyvbNE38N1NP4b4V1S2l2ahMQjDlWEm2Gg11/Ah80W+p80t9KUnZXXCKJ
         2/LX02LOj8anyrcwZtrv46K3jCqahuTZaFzP9lpjyIcPv5nXpy89aKEiTyXOUD6FPRzA
         ZuZdKMcVOogeIZ9yX4uP2DcbTR3Sw/1tm88VvCJ35Dq2rd06F4QkhXDXAQrxwQw41tSt
         nMnvU3GcV71cq6l3GbeDnVW9M8UaqIc1IglBFEjKIkP/iD3aTuzoIXns7zUc5QfB7DqU
         qJY5U7XxHsyzw4WsBG0SxFTgwN7vNnu+EHZMk/9uHWD8ShvvE54Zg0U+MRu8yAJn2yhn
         L5VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779197134; x=1779801934;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yFek1k0mWh/Ty3927Ox1UTfk318qie1Wk1ylGq+Jroc=;
        b=VzoeJ6OkQZpfN1vxGbB/wAD7HvNhCBMooGdrxMMX6+hHKVv+v+eyD7Wdre4SQBY34J
         5KXWlrWggjI0/Wrb1bjPdWTg/qqOK9/jv+wMvQ+mfSWewcHhsdXHPon9lWct91PIXXWi
         OP2gQBY3KSzUSQepzzJRGKtnkRrcfpftggm2lAfGI+DNYsYApg+FEUc9p9eoN2h1nwgD
         CF0EXg4YqxpIuxYE/bPZkSyYcxaNYzCyDaxxpVZNuLml7yi/Svb07/4KGeg8t/ZFDocq
         VnEn4JEvl2sBWDN+RSlxxAQyYFo8xBmZDIy54Fag/lM9aptEZLf9KwLuuZ02V0b6CuG2
         bYeA==
X-Forwarded-Encrypted: i=1; AFNElJ+WxExhuvRjC/VAMu02f0FSZGH2Rk1q5/QX0n1LqbrP/eYPw3xW0tt6eDq7W0Y4pQaUG5tzX8o=@lists.linux.dev
X-Gm-Message-State: AOJu0YyeV3xx+K/Ip6ofmb8xytwLcs85FD9pEQl1tyd7WqcEgIGqMV3C
	FYz1cp2S91itRteIv0XfJ+f30epMTJSGmpTbWeYrrT1L8b3sgwBCn+uw
X-Gm-Gg: Acq92OESYLiLM50pBI5A8yxVUCB1EGIeauUMlHOxCZw0PPfa+H7LLwLD3dE9iZJXGa8
	HrpVYQiEAby0tJdRB2Lk3ye4d7wWRPFBFxEDpGZPQjVozV6QhPuw2wuVJtXYBop+ywAzJNe+e73
	vl1e6pwRX4oERvQZmu6dx1N6bH7e/6jGi9PolRYG7Z8KVCQXEHt/J6xUslZvkkmS4jjM3wG9Ljp
	5ouqzFHdkTwJHDyG8uwbnYFStwUuuwL4jJJm2vF3lroF97QNZjpJzvJKIORFpyp/bbm4FT5Jk5P
	Hd2tBUmb5H5JHKbtGJJ0Qu8zX3581gNBLoqR7tuxbKVihwLVjQi3nrBDMxG8+pPUKOhAKnt8L4T
	BoruZhBMH6n3gxcttLzjA55oOcWxY07oiuZb+41GcBAkThCw835kXKRTMCmbrrePNEAj0gFgUhN
	MfF4m/5YejW19UN+18blNrVt8KZDrzZB41zfd6U3O0DbAjUIDKx176xwA82f2gEwWfiP9anFKFB
	xK/x5RZ+ZMUUTQHctPpC73WCoP1OSA=
X-Received: by 2002:a0c:f08f:0:b0:895:498e:e9dd with SMTP id 6a1803df08f44-8ca0f64306bmr262712696d6.2.1779197133608;
        Tue, 19 May 2026 06:25:33 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ca36097a26sm90563716d6.17.2026.05.19.06.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 06:25:33 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Yao Yuan <yaoyuan@linux.alibaba.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: arm64: vgic-its: reject restored DTE with out-of-range num_eventid_bits
Date: Tue, 19 May 2026 09:25:19 -0400
Message-ID: <20260519132519.2142458-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517174955.273004-1-michael.bommarito@gmail.com>
References: <20260517174955.273004-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Userspace can restore an ITS Device Table Entry whose Size field encodes
more EventID bits than the virtual ITS supports.  The live MAPD path
rejects that state, but vgic_its_restore_dte() accepts it and stores the
out-of-range value in dev->num_eventid_bits.

Reject restored DTEs with num_eventid_bits > VITS_TYPER_IDBITS before
allocating the device.  This mirrors the MAPD check and prevents the
restored state from reaching vgic_its_restore_itt(), where the unchecked
value can be converted into an oversized scan_its_table() range.

Fixes: 57a9a117154c ("KVM: arm64: vgic-its: Device table save/restore")
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
Changes in v2:
- Trim the commit message to the root cause and fix.
- Shorten the in-code comment as suggested by Marc.
- Keep the validation logic unchanged.

 arch/arm64/kvm/vgic/vgic-its.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 2ea9f1c7ebcd0..1d7e5d560af4c 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2307,6 +2307,10 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 	/* dte entry is valid */
 	offset = (entry & KVM_ITS_DTE_NEXT_MASK) >> KVM_ITS_DTE_NEXT_SHIFT;
 
+	/* Mimic the MAPD behaviour and reject invalid EID bits. */
+	if (num_eventid_bits > VITS_TYPER_IDBITS)
+		return -EINVAL;
+
 	if (!vgic_its_check_id(its, baser, id, NULL))
 		return -EINVAL;
 
-- 
2.53.0
