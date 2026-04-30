Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663B73932C9
	for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 10:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777545455; cv=none; b=YOccJAfU19xLKX1rYEge9QYvfDnvzbKCyc5cK+8qBAIvwqM9ekr8yiFiv9J32w6RmnNmeqlTZPbsZTt8zzHYh7JdbbLV5lNv25TpjfrUqfy8cC3BapHzmoQENjjv0UgA+XsGBj4Gpn4qw8YDhnhNyR6nnKePsC50ilT5bvBYUi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777545455; c=relaxed/simple;
	bh=aBUqyz+8tZ7QS3WaHaFr3XJxACwh+4bujNo3pg9HJpg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Nlrwv1bzvGShKBD/oDu3/Ddptj+JSjHgx+5qE+AEnUsk07azDMxYaZoxOfVx6bHm4hsqg2t/cEeeIQoPQWEqirJ3t4jDtN106kUPbQf2bJTu3FJv9cf3JAJ6hLa2d8Le9L9DDjp+bTlMfcT2+D1Z+Mkg+j9vkh+lb7wnepZFRxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EB1U22Z/; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EB1U22Z/"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43ff19e54beso545133f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 03:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777545453; x=1778150253; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CE7ryhQPSrXB5CO15AITdkHOu/b63A3t1puDBO48YFY=;
        b=EB1U22Z/yJ11FieE+Ifg4wMxLVj7jskhIuuEdjmwDmPykOjXuv1VCoyAb0vIAfeTth
         3d6yPB9BZTJkBTeMHOPTOKKxlZ+sBt9VCrWtaF3/4FO5PuP6xc5f9+PiEUVM7dUHs6g/
         zcJDA9gGDf3Pv8iPjEas9w6Xg8BiA9dIZ3YhzR6J6SFrQKYGngCcfRo3u35/bhOV4JrV
         lOAuQR957wcXb9hfpfx5ZHwnKP5TRjsqAonjYal8Bb/ovE+mKyeI1strT9IWiZN5cBSP
         8cIezbVJvdpyepXmS/2zVQ+KMNluFM1ktansrt5wRMCCeQjlmyBR49321bjxd1q+XuP2
         ZnQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777545453; x=1778150253;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CE7ryhQPSrXB5CO15AITdkHOu/b63A3t1puDBO48YFY=;
        b=WxP6Uv/iFDWBBGaoBygGtelIh7aDaIaRyJtCRe70WIbGsIHH6rdfcYySSS1dfP3E0w
         C50jfu9BP+8KuAbWb1B2Q75hDCCB12l26NjpUat3AS84RGJCTT3yBe7w5GQkghooB4bn
         eaYUS1U00s3/oL/yxBNKJ53GguRzeSyGJ1Iu56MqQBSkKjFe5vEsRGXeMAREPpmsiWSX
         N7U6vweP6pgF/NMUUQ58Rp7PcHS1iqjf54GWMfyrfWu9K94o/KFqdUwSisEITLYcBVSp
         Kgw/4B5xOAK+GcdFKHCJwQDeRqcuRrNjwDyrXC83GU2G+hZnBI2soq4cUMp4ar6o+Xpn
         U4ZA==
X-Forwarded-Encrypted: i=1; AFNElJ+GsjuguUsfZtjPnicibU5YHR9j26bmj5Ti2z4/oy+1NU2L222WM2HnHB85FElWO6priRLF/AM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyuowEYiS/w20p1F6EewByuFtQSuUTFO/xgPnXYeDHSI7cyWsS9
	1/WYRmTOVOwawXV2rK3UK4lm3Jhbkq2XWumWadwFni6hu6IUwcGUIKi/a5QK9QQAYWrXu7QKJZC
	F45PHNveFEUXxPA==
X-Received: from wrbfm1.prod.google.com ([2002:a05:6000:2801:b0:43f:df99:cb43])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2906:b0:43d:613:4036 with SMTP id ffacd0b85a97d-4493eb6d792mr3587302f8f.37.1777545452617;
 Thu, 30 Apr 2026 03:37:32 -0700 (PDT)
Date: Thu, 30 Apr 2026 10:37:24 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260430103724.2151625-1-smostafa@google.com>
Subject: [PATCH] KVM: arm64: Harden clock for nvhe/pKVM
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, vdonnefort@google.com, tabba@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Sashiko(locally) reports possiblity of division by zero and
out-of-bounds bitwise shift in trace_clock_update().

Although the clock update is untrusted, we should at least have some
basic checks to avoid the clock value getting out of sync if the host
is buggy.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/clock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/clock.c b/arch/arm64/kvm/hyp/nvhe/clock.c
index 32fc4313fe43..a7fc61976fd0 100644
--- a/arch/arm64/kvm/hyp/nvhe/clock.c
+++ b/arch/arm64/kvm/hyp/nvhe/clock.c
@@ -35,6 +35,9 @@ void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
 	struct clock_data *clock = &trace_clock_data;
 	u64 bank = clock->cur ^ 1;
 
+	if (!mult || shift >= 64)
+		return;
+
 	clock->data[bank].mult			= mult;
 	clock->data[bank].shift			= shift;
 	clock->data[bank].epoch_ns		= epoch_ns;
-- 
2.54.0.545.g6539524ca2-goog

