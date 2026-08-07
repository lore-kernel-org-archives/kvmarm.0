Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038164756C9
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 16:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786121037; cv=none; b=NdAr6cvAL68Tb6GZPVsmUs3qrNp41ErP1O33Im+uNVGaZeu0wiGGvEWCut0Oj+QDMLkDAXPZgwjYBRApD0XEMKCfQRSi3CI7AOwHHdxsCkb1x1NMuOmoDPx+qwIz+TE2Ayz96kQI3vVH25w8TR6/sBb9OVQOyHaoVd8GLgOMt2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786121037; c=relaxed/simple;
	bh=5ifxU6j26G5OaYQO/lDPi7ymHnNqbvnUe/Av1COaOCk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TQRE80gIq+h5sptzMtCIkPoVtU1uxnhNnUB4gGqMciKf1EbgGF8VQkO9DxD8YIU7HQh3NVUz8qU1iNyFJQhR7CF0Is638a39Vaa1cExlkqnQLYN0MwrEYqkLMg5pxZX0ak+9MtsuB/cb4cR1yVOK25XdCpdz5Bp36nI2vJcPrJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PYTnLVpg; arc=none smtp.client-ip=209.85.208.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PYTnLVpg"
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6a17bf3d42eso3261791a12.1
        for <kvmarm@lists.linux.dev>; Fri, 07 Aug 2026 09:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786121032; x=1786725832; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9zUqneyGoRi5zO+Pb+RiK7Bj3mze6rvm5S1Nt9aVy8g=;
        b=PYTnLVpgSC8BDycCVaIg3es5TcC5bYkwdTw0MfnPxujrIf+vDOxuL5Cs/xQsD+aRyH
         dZgAj9/GIlThlvbF6wer6mz0x4DqM7KraBH3duLmK5Rz9dUvPqoT861wgkR4Iq4k/Jw7
         gN6QwytaXxk/FQiDfiLXt8H6D8j8dSuAyLPkekKZAgvfHghx7V7aIAo5dsScGgpR5g8m
         WaS60m9mylj+Qtx/o8w7Oz3mNaFPecWrhyVBOXCCx+FVj3vuEtZREtJVwZLsZc24D50E
         GmlHXmyU/zHknrPVsCcUJW/aGSsmOgWu3TZ/IHdpJHHGOVyRHFDdbRT6SSctrpaHha9O
         24Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786121032; x=1786725832;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9zUqneyGoRi5zO+Pb+RiK7Bj3mze6rvm5S1Nt9aVy8g=;
        b=jpEdxnezqWTUBJMkf5ytaZbjY3kdHNRb2l/46i3j8cNI1FdAlEB+osBFRX9xog6syU
         Qh49wD+MmXF/bgjGXd1Z0muCabbjXG8JEQp+WFXePj/lWAP6gizgAZKIcpk2lIP1+E/f
         ORRB1QtImUevujPbBl/RlKMs9aok3CqyEL0fDa6LpDZsn4dkYB4dMtSVhdGg4hNBzDwv
         JpPwv6SpAW3tr94lGOrNcu3RQCR/41GDP9WxJBezKONzfDg/gKm8Bzvkh6tn8cFDDNZS
         RKtY2nIyIbHoi19tKwp+PG6IAKvQklUb1uJ9IiFtKjZouW/9KHQ5+Z4aGxWAduXXlYAt
         gtNQ==
X-Gm-Message-State: AOJu0Yy59vhfr/4KU03KE1AarwRYAkdb4e/w6mCLWNN9i0xhdn3aYCd3
	9L+inCvhHZc0JZUsAAXhhby6WgHheoyRTGexT2OpmMrdevtEWR4p0TOFR0oEjVQOl7EXp5+xYC0
	nmBb9YqGm+3D46BAkgGoO1GfkoOftlw==
X-Received: from edbfj6.prod.google.com ([2002:a05:6402:2b86:b0:697:8356:d9d6])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2394:b0:6a1:7718:ad44 with SMTP id 4fb4d7f45d1cf-6a17718af13mr8635625a12.21.1786121031567;
 Fri, 07 Aug 2026 09:43:51 -0700 (PDT)
Date: Fri,  7 Aug 2026 16:43:19 +0000
In-Reply-To: <20260807164322.2970811-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260807164322.2970811-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260807164322.2970811-11-sebastianene@google.com>
Subject: [PATCH v2 09/13] KVM: arm64: Trap & emulate the ITS MAPC command
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, fuad.tabba@linux.dev, joey.gouly@arm.com, 
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, rananta@google.com, 
	Sascha.Bischoff@arm.com, suzuki.poulose@arm.com, will@kernel.org
Cc: kvmarm@lists.linux.dev, android-kvm@google.com, bgrzesik@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	nathan@kernel.org, perlarsen@google.com, sebastianene@google.com, 
	seiden@linux.ibm.com, smostafa@google.com, tglx@kernel.org, 
	vdonnefort@google.com, vladimir.murzin@arm.com, yuzenghui@huawei.com, 
	zenghui.yu@linux.dev
Content-Type: text/plain; charset="UTF-8"

Parse the MAPC command and verify if we need to do any updates to the
shadow collection table.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/its_emulate.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
index 071a08d3602d..5629e2a070df 100644
--- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
+++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
@@ -332,6 +332,13 @@ static int process_its_mapd(struct its_priv_state *its, struct its_cmd_block *cm
 	return track_pfn(its, device_id, itt_pfn, num_pages, remove);
 }
 
+static int process_its_mapc(struct its_priv_state *its, struct its_cmd_block *cmd, bool rollback)
+{
+	u32 icid = cmd->raw_cmd[2] & GENMASK(15, 0);
+
+	return check_table_update(its, icid, GITS_BASER_TYPE_COLLECTION, rollback);
+}
+
 static int process_cmd(struct its_priv_state *its, struct its_cmd_block *cmd,
 		       bool rollback)
 {
@@ -342,6 +349,10 @@ static int process_cmd(struct its_priv_state *its, struct its_cmd_block *cmd,
 	case GITS_CMD_MAPD:
 		ret = process_its_mapd(its, cmd, rollback);
 		break;
+
+	case GITS_CMD_MAPC:
+		ret = process_its_mapc(its, cmd, rollback);
+		break;
 	default:
 		/* Passthrough everything for now */
 		break;
-- 
2.55.0.654.g21b8a5bc05-goog

