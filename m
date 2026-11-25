Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795589808;
	b=Mduz6qnSM9qPd2/XGsTknP+WG3WDl3+2Yl/YvLA0sm63J6h70uDrm+5zx6SKPluCo8NH
	 8ZtDzs/ol5zZqBvtrgJ13peIDL/I55MpWzvZQ/PvC2cp5fefa1YEifJMkEMwrsV0Q3PMZ
	 1nV7WofaG8gi115TMb68G9cWx6ka/9RIWLMjI1bWU/8RMYFgkuUsh4bHikRAORSteKBmq
	 lDJBGugWSg+tlO+FdCLWtdcIA88zblHvNZwfXQIYinc9YTWjaNDpgVof5qQHGk11/MlWK
	 1idjWBrWfo7we+9JoWcQMcTw/g0igqtzRt2pXQ209DuHRY1Q6xyoipP8/Kg+J1qgVhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795589808;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=FprakhUf8NJ7i/pJUhVF+s5uu9taLAIMe4T8Serof+A=;
	b=Ob7Box9s07zdShgR9iJRU6XiC+wBsS4/v4e6e2whfmL9aLbILmmplnHf3NE4XnO43qaW
	 QCxB4uo6RhLWkEq/AL9KhRd5i6+wNJib7H/pRfmXybQFDvZAjjqAuQ2ow+lJ+158Jkucq
	 iR1K0dWX2egTjlK1FXKXuyYahiIobpvswg7QFshuWzQs6nP3YxlSaEnAkiSGUwZSAnaY0
	 4jb9Mv8o3brTBEtz2RC2hvIx2/PdYImI4MJ1kjabyn0fBR0WIIHUOtLmK5z/NROZOOMXT
	 k2WGL+0W73sszN/lePWx9abyJJTfNQ0PcZ9aL2VTDuC52B1IMCPNDPa3vRYZmEbqxtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=YtlMNWYB;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E040F606A6A5
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 06:56:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E040F606A6A5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=YtlMNWYB
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48dfc0421d9so5017156f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 22:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795589806; x=1796194606; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FprakhUf8NJ7i/pJUhVF+s5uu9taLAIMe4T8Serof+A=;
        b=YtlMNWYBTcj+pJV9/Xc4YoFmSLTLGt3LdUgeNHcUuXEQYZKvitPPj0SYVJYcVYXOUE
         E4v1dTwKovaaOVNu/oYF3W1SVgsQ/7da6E2ezBmupKhl6W/pS0/GTaQMeGCbUTCh2dgd
         5pcaaTWVsc3vXqulq/wPrPa8cKlS3cUEOO6TE6TlMcpueGkVzDudRHLJrNQU7NTcOw55
         TR6MikTXv/jsemxumqGSqRWQPlpBIuLmKmstTr2O7PZxq7VpYzZvxMcuDzQKkN/KlYO9
         f9GdmWSzl3s9BfE63M5XhpOj/DcDpJLxcr+od6I5eIt0UIjROkbk+SnEsM7w/M8Xch9V
         Hmng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795589806; x=1796194606;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FprakhUf8NJ7i/pJUhVF+s5uu9taLAIMe4T8Serof+A=;
        b=quG7JtLUUfehOlCamunT4sSBKelGvsSRpxgDP4Zxr2DQpQFSbF8djfxgZLOH/YDWyk
         syrLCQ06vlnROO2/r0PGSjxoCFVvUwKT7k123jS5JdBTaKb3gUaWBGeMeHFqdaG1pQ0V
         6uc1JupYjSGDJaOnQg3KkGdJlHDNb5JWTxqoJSJnX0lpfBu+UT47KNYXn81Akt6lI141
         1TPpQbmFwb+IiRi+PoLUkuZOHnAK34pQELpD3+XYnw8bxFId1ve0DMw8Xm3ITFp5ebzh
         7yD/kbEClCvVH9P2thIr+zYVAi8lZu3oXxxBxcIFkW9/ogEMZvzx1MYBUz3JM4kCuiGv
         lAKw==
X-Forwarded-Encrypted: i=1; AL+hErE+WcmLtoUUHGGDQHwlFGIjSbvl1hHXJn6MDw+r2it9vR+CYbgWn/bC20AnyLUKWzEnqtT/PMA=@lists.linux.dev
X-Gm-Message-State: APuU4Z8iqSsTsTbZld+T8jQmxaRE2QF4bGXmGu67XTHggyRLAOz9YbL/
	a2nl4textsWNlTe0710l0PYrDtUsKyrwN8hR0M8FEU/d3r++D1QnjpyjOQ7N+8vKCX0=
X-Gm-Gg: AZFdTZcHQfkdiH0lb5nidh/r5OwLPQwDjd9zhjmTt2K7eA4YzMZoEPP/Lgr9CsBGXs4
	7cx/r7+th2iKRFM2xF4GoZGEfl1kCpzkYR6hWMBYFMkgkamw4qUIfH0cojGICrgRNsUwLfiEUc2
	xgghHlM/S2Ppe6oW2jXUmMUhAz0YSKLbXf9un7ZhGZC16nqiKzXibhgO9i1jFpIc3sXaqTd6+Jo
	1VGuV6p+3UdTThx3WPFrBgi+0aPbQo554POTpmIGH4/Cd21OWMNbLchV6CBwAfsH+X+b+XVPpUI
	4eGaq3EaYvyiTHihwuSuPhab6uT6mPAeTAmXYz3Hqnu6zrr24rkg7qwmIhBHa5W5NBw4jmgqAso
	kpQKcmITh6o9m9P3SoQSYNw0wflqyD7k3oGihDvMhtDFWtEem0VTLvpUsPgdzurMOZWmH/Wu53E
	0HVCCTeYoIVInCKnL7vrYLZ8VnL6alQBOpZUHKi4y0nSB1mEu6jMnG0rnYXiZGVJWj9G9a0B9wj
	K6JD9ehNUZOhe1zTqb+Fwt14kV9mtoalMtpthdyAXiOPMkfcm1yOzhkXmhn3eFi0pMYwjOw9GaK
	7+gnDyPRSJUvu7ekSu8=
X-Received: by 2002:adf:e014:0:10b0:4a6:b87:d799 with SMTP id ffacd0b85a97d-4abb400bb42mr23914238f8f.17.1795589806244;
        Tue, 24 Nov 2026 22:56:46 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ad644140b5sm29125406f8f.17.2026.11.24.22.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 22:56:45 -0800 (PST)
From: Dan Carpenter <dan@pereq.eu>
Date: Wed, 25 Nov 2026 09:56:19 +0300
Subject: [PATCH v2 4/8] KVM: arm64: nv: Discard nested SError in
 kvm_reset_vcpu()
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-double_exception-v2-4-224689d8a764@pereq.eu>
References: <20261125-double_exception-v2-0-224689d8a764@pereq.eu>
In-Reply-To: <20261125-double_exception-v2-0-224689d8a764@pereq.eu>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Christoffer Dall <c.dall@virtualopensystems.com>, 
 Rusty Russell <rusty@rustcorp.com.au>, 
 Marcelo Tosatti <mtosatti@redhat.com>, Sebastian Ott <sebott@redhat.com>, 
 Eric Auger <eric.auger@redhat.com>, James Morse <james.morse@arm.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>
Cc: Karthik Bhargavan <karthik@pereq.eu>, 
 =?utf-8?q?Cl=C3=A9ment_Blaudeau?= <clement@cryspen.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 Dan Carpenter <dan@pereq.eu>, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0

Vanilla KVM stores a pending SError in ->hcr_el2 but nested KVM stores
it in the NESTED_SERROR_PENDING flag.  Clear the flag for nested
SErrors when we reset the vcpu.

Fixes: 77ee70a07357 ("KVM: arm64: nv: Honor SError exception routing / masking")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
v2: New patch.  I split it up like this to make backporting easier.
---
 arch/arm64/kvm/reset.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index a5d298d5ce61..d80b38b2ce6c 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -209,6 +209,7 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	/* Discard a pending SError */
 	vcpu->arch.hcr_el2 &= ~HCR_EL2_VSE;
+	vcpu_clear_flag(vcpu, NESTED_SERROR_PENDING);
 
 	/*
 	 * Additional reset state handling that PSCI may have imposed on us.

-- 
2.53.0

