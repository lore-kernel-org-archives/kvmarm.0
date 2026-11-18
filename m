Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034135;
	b=RNE8U02AcNSqwUO/UOH+Syhvfvez0qsvnyTwYJUag7QRfMXKrq66pWdptQ9QGudLHRD2
	 3uoKHRlAS09oXrHVgDLAjCwlSPJ2DTQCAj2/ShAKJIHWCtED8549UTZycRq39+/eelcZo
	 ve2dPR5R9Da2gTit1xf2ZWTHaeIP0JXFX5UY6kNMmIlZAob0mkNvwi0dpMeV2SY9+w7xy
	 yqQro97+qFct9152Z4o/eUgCoeIR7XQ71eMVUFdLjCQTsRKaAMrEtbYT79bwnuNOuYdaS
	 wiiLnaOASzjqSzL99Edv+J93qcnCqLf9IaRerYu5BfRj2ESzTS+0Fqgs5J1yibzq4VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034135;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=e4z/RAPfyhYM0nAZxFd/+R4Vt1inNTW4BSIaRYbDcgw=;
	b=tgsVOZs1W4e26m8wr1DckzEFQJ/J++Tr//alHRoa5YDF9M1O0NTXCM0zb/e758akACWJ
	 AQB4aSNcTTTtZ5uWOR+UtlYbXIiyQxaGxQ4/417uvaAXToAYXFeHAF16Fq/Z1NuHh1ik2
	 sI2MjbWZto/sBPNsCFSybPARlc6j2qqbdNmagPC9Y3HiOmOv+s+xzxKF/E/91PKR+XQCf
	 pfReRg8bZsa47LTvokThFkLNs/DcGitVvsQYzdchC6bGeDwUgoVu522xLMzg4J157GRbe
	 FhnS9KHmmTRKaw0RXw75TRZkwWs4MI45/PpKAnDGAAz8fTuTDzbb054p6WdGNDqq7JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=egXfXbVK;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F001960A2609
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 20:35:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F001960A2609
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=egXfXbVK
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4b26d8d2498so1446477b6e.2
        for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 12:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795034134; x=1795638934; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e4z/RAPfyhYM0nAZxFd/+R4Vt1inNTW4BSIaRYbDcgw=;
        b=egXfXbVKJEK3Fy/ZfIW4zIO/LXHVE+QRBw/RlD0jnDlMmnlWtrUg6Wl+XgJhpMIKjP
         EB4B/raBt1XX/K4sDWVKXtj1ueHX80nYxwfz7tDzdIy69Do4Bmi6P8EWhvq2jri7WZHe
         5P+cdwSASNioZJ5LSgeTCi3Duo8sehOhCoB4zSalElJ2UetZZWlq03Ho/tJv1lWadwU/
         Yqng2nA/o054jhCCrFS/4etjrKWGPDk02Plr+NHGrgvbLpAv0yIHkbGNx89Ig1ADq2T/
         xkwrVbIUmwaWW4idskJo8UJnym1xCsSK6Z3cR0JA37TFn4yZs3gPBnGO43kSb7vltv+B
         KPMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795034134; x=1795638934;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e4z/RAPfyhYM0nAZxFd/+R4Vt1inNTW4BSIaRYbDcgw=;
        b=nNbQxr/q+N1sYmCftkjpAXk0j1EWBSp66fqtIZlVeFjDlD9d6Z/QmmuoIYPF6cevuz
         9h7wu5qPpifQQcNhneXnfwGKpsAEqAqrbRlaZZdXSXBFyjLFMgFcoj8XXi9ozzSexJf0
         hJ6A9wTf11BzW/zhHkONbEQJP/drPOph3GPqOIbwKRnxQXg6jdqz6nEqn/eSX3kPc1n4
         AwLgOpw3jMOzSPDWA9xwyZ3PvknE0JXPOskHUvxsasc/mReSKj8vRq5bBAkZ+zpdN+gY
         JteTHJuqcG3EJWEGNjvgA2JhSAZDCHxbam7O8qBy+NL8yzVy8GecP2dIW13rEcKLbB+b
         8niA==
X-Forwarded-Encrypted: i=1; AL+hErFDkjQrfMHJXCSBBAuQ/Ij62ZiwZHqUbpn1TuDlHbqbqEuugnSy5nFDO+VuTeftVP5N4wSnDp4=@lists.linux.dev
X-Gm-Message-State: APuU4Z8YRAvRr97nnbUhQmn3uJuo/nksCVa5F2xrnWUpQGFNmgu6gF6L
	ClAABKJBH4iwW2tas+yLAHsVar1fizVdRLL7xBL/Rudqz2+fdy+G/Y4kjpE4A8ywEPa7RlFOP7q
	kzilj24QX1TBLi0Xm7+216Ioz8A==
X-Received: from ilka13.prod.google.com ([2002:a05:6e02:e0d:b0:549:a2e5:e0b1])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:308b:b0:564:4d77:7051 with SMTP id 5614622812f47-57740a4b41dmr5099085b6e.26.1795034133585;
 Wed, 18 Nov 2026 12:35:33 -0800 (PST)
Date: Wed, 18 Nov 2026 20:35:32 +0000
In-Reply-To: <avzaDnFRQ2GTHDiN@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261117204535.4036191-1-coltonlewis@google.com>
 <20261117204535.4036191-3-coltonlewis@google.com> <avzaDnFRQ2GTHDiN@kernel.org>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118203533.740768-1-coltonlewis@google.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: selftests: Verify HCR_EL2.NV1 is RES0
 when E2H0 is NI_NV1
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Colton Lewis <coltonlewis@google.com>, Marc Zyngier <maz@kernel.org>, 
	Leonardo Bras <leo.bras@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Oliver Upton <oupton@kernel.org> writes:

> Again, comment would be helpful for why this is done from userspace,
> i.e. the RESx as seen from the guest POV is stateful but the value is
> ignored.

Agreed. I added a comment explaining why the RES0/RES1 check is done
from userspace via KVM_SET_ONE_REG rather than inside the guest in v3.

-- Colton
