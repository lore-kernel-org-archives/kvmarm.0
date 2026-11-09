Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794217340;
	b=zSpm/9jpYlOhBNHK4PKFw+9/LV/bFu8riS+Aq1ylf8VgTEKh64cJjV54+1+tH69Qtqq6
	 k1Td2xJMA1EmabWBIQnLOWqcb85T+BzX4XQ3WlJNAy5Wyb8IfiZajf8LMYeBnhtlHF9WO
	 FjbVHzuT1MbvVYjQvlqrxZjK3bg1vR+7e/qGygmvi8bdcMpLynzVw/6djD2v0RJ9ZE52B
	 IggdsyAtklDIkJudnxGPq2rvtL+c++OEsrAwQ1pqo3OoTRt0/tALpd6lv4e94VuFVIRES
	 Mi/S+3XIwlT4PmQm9l2tOY1i6gdDcdQtXtC4x3mcyC90CaOWP4AabmYd042prpAJ4pg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794217340;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=dnTFqC7NFZ6LKcry7zosB7nFvDvPqEPM5rGL/V6wgTk=;
	b=jwaXJOr8lLpbEdJi/OVclszqEXTTSrwer53oFdIgFMHS0H1derqMUitmVrOGXJLDecnU
	 vKahu1akhduDoUQnQaiN/3mCINGLpKZOK+aPkaQ6ie2vvwU3gM1N1YXcFOvtjmZ+s0fqD
	 FOnMrY65Ib0LHN2oGl9S9r5upP6/JZ/qgBfC1WLeSRLa3C5mDyGHn/Fu6IfE5aCVapVcI
	 s2qPQN/DUvOMnSuiMp7XfYO+6FxNybSgrK4XwcLQnEn48V4sysZmePLDulcVT1/901W2r
	 +QtTnSic5Vu3Bb0BT3fL9iGVAdWnNm4Q8QsOVNdmCkCD7BeDPdXs+YuTlgiycQte6+Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dh3hYC8y;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.42
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E96606A334
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 09:42:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58E96606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dh3hYC8y
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5c14bc5a743so3604e87.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Nov 2026 01:42:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794217338; cv=none;
        d=google.com; s=arc-20260327;
        b=dPXPGKTKyf7Pi33FZoS6FQYwJUScT36lHiGjKYe3HlHhh5zV9uGtz1q2xTGCoCTsHT
         Qx82oZPp7gUv+knomHme7ic98mMs9qX4oympD4oHw4AFYS7y8NGu+Av8zq5mU6Uff3Vq
         XolRW843gUjgU3xqzBgonpUGGKOmElRPhCpsHsQKrgcofY6szVTLNJaAsdDOL2xFEHQn
         2llEfr0kcXKcQfNmhUyaD8EcVkyUH2b0U9pzlVYFBidseG3F1VqCH3utX2K5JSXRcuSg
         UMIgF1ZDDikTpFaMHr03jiN7AyENZtzLcu5ffVViIiDP0K7/qU7PgpWHZBW2NpQwFdut
         9DrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=dnTFqC7NFZ6LKcry7zosB7nFvDvPqEPM5rGL/V6wgTk=;
        fh=g1TGnvKHy+f/vJI+su+hESscBL8rR2yPcDiQD+7QQOI=;
        b=h9ib7ODpoFMnbTN8yIbH7AOG+Ez4XNff8jHbiCFU65svJJfrIBoSozJ1KxDgIIEnt+
         whFznvGAzc62pSowcomKTL7x2gRYJdHKr1MbOKlPaSGTwa3k3cbeebnelVaMG8D5bFKQ
         gTKW70/CRHYU5UlKgcNehzwywqwnrYO8nZcCLfIdT35R4GY2fuKraxnTEs0sJY/M+8xY
         hrlFjGzVv/qoM7l8eMs7GvMKhcEiM+OuU2yGQSO/F5Zo3Jt+qxsiMQ26tA7IDPb2QX/a
         3SCligdPAWdzsn7+SIR0XaDvZULxxVLW6W0C5XlIOE3o5hQxOPUbl8FAvGbD0NQTAOaz
         Q6UQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794217338; x=1794822138; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dnTFqC7NFZ6LKcry7zosB7nFvDvPqEPM5rGL/V6wgTk=;
        b=dh3hYC8ytyinBIBrf/Dkz8AxigUv5PrRArqQPjVOxT/GCmWiqYlHi6as6KqHfkXYQN
         asQag+03110ET6dqEZjE6f/REwP8sWWfwUSUBA/lWuvbnbfLPI7cLx0ICzbcc7tiKH0y
         DXN4Q66roTbbb3Wrv/gZs1YrA0AYQhkOoj1OvPyBewLio0WHaYKovdEwgBdFYlPHHvsW
         onDvIfy4Qk+rbmSErPiQHiPGfnsH1JAGJcyCXj6rmXrNMG5rH8uV6mUKFjiF1O0Okjk0
         gvsvLrZTfEfAPi6vCDQxoC2MjxnhNeJseLHLz8vxvvYnrGyCl2Lrj8oBMfPyu7C4/kSm
         gUSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794217338; x=1794822138;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=dnTFqC7NFZ6LKcry7zosB7nFvDvPqEPM5rGL/V6wgTk=;
        b=aR7QYzu3t66NSD4Fs2fLGOPdEXdUt0DmvYNZWCke9BxpCiBiFVD/nOx7f7x5jN43Y+
         J048cq7wWGibTteZ7khRiBAV9tVuXQSKgTH0Z3MSmr2YOMQghUJ1rimfMdN7t5TvDcUS
         vX/vd8OJtQefCS6TSU+q7SAvsXlMujNDSnrjXuwfKhP6/+IgjRPSweAKLxbAgFTYDHd0
         Et7PIOp1RRO/xgVexz6HDcdTVGO3s4bjn391HCEvXuD/+v8RVkdmoxByGj4Alw9M48LV
         iRS6xrGl9yljDtn3J/gqXDvj0hrPsxEPn3QwjduhhNy8M1az0Moqwg+lI6ka2VljVWLP
         nPBw==
X-Forwarded-Encrypted: i=1; AL+hErELDDnJG5Nwr7B2CPKp24J/8hfqqEC2IEF3kELDkdNoKc6/DfsCuVYjiRlClrNIpy3NdnawV7o=@lists.linux.dev
X-Gm-Message-State: APuU4Z/pm2DWDIelXwGVCfoeVThgPNoNnJ+B+PI/HLGyLbw7zjHOeVu2
	m15irhuNpAeRTcTCIm9du+7Ndc27OffVBLzkDx5umwpNDJLZXEIgZ7/MbCbQwAqpSuzz5b1v9jJ
	0BWWUX1Clk3WI4yzQLJvUHNRQg18RCVSMJV8//snR
X-Gm-Gg: AYBFou1D1MS5R1Kk+l4evlYbsNX8iB05hA1kRMJpOfupqVc1dxG3diintao+oU4GOpF
	zxolWIHC+yaBClE4G/VTLZWMANXTb7FAyM67rd9HElDrwfdakMOt3HOnSaUPUOaqvwG3wVBQdgb
	abVQjAV3BA2aQ5PrXAk2TZwZsbhC7khdj1SufEd5KkGV9x073Hwp+U20wXQuSnq7gf3n2/Trwpd
	fiJ9SaVNzwOFQy/b2TC80QvvLRw0js/95ywmvM+57viFNIrV7ETcU29e2RHezqEbuj7oogjAFd7
	7Suzq5fAWSLQ9V+b5cB0b7LCvsz7Bs/Q05eH2AuNdR9HCb70OCA/JDeqjwlUe1fNbItlFGz2Z+l
	BeVqVvnLAMN0jFPwsNMueusjeFcxw8to+q3DwZgvAdmjj2hlakqtI2qz8VZO2O3cXjIcQX9/hj3
	6n5ZcYY3K3rOI4dkzhKT/7Wg0dr5Ym6ChUUYMcsFcfHueS0H8=
X-Received: by 2002:a05:6512:304c:b0:5bf:f81a:f24e with SMTP id
 2adb3069b0e04-5c00bd5bc9cmr144934e87.10.1794217337930; Mon, 09 Nov 2026
 01:42:17 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20260922071945.693714-1-fuad.tabba@linux.dev> <20261007074037.316564-1-fuad.tabba@linux.dev>
In-Reply-To: <20261007074037.316564-1-fuad.tabba@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 9 Nov 2026 09:41:41 +0000
X-Gm-Features: AclHuK_MaYET6PTkt0ZnvA66k0DV_1M55e3jB2HzY2bpxHczb0VPvo1hIAKLqfY
Message-ID: <CA+EHjTzaJx2nV_9YEExgYn7STSP1Kvhsqan8va8M7ba4WtCiqQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] KVM: selftests: Fix incremental build dependencies
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	James Houghton <jthoughton@google.com>, Will Deacon <will@kernel.org>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Sean, Paolo,

Another gentle ping on this series. Is there anything else you'd like
to see before it goes in?

Cheers,
/fuad
