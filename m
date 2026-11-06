Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.146
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793979390;
	b=E5tHq04k8vZXeSN1R4DGg1dQcpUMQxQjrl2Rh7/DW0hlpBv6GMgy7kg0QH2A5Tzs0Oer
	 Xq61LwouKKwtxP4e1y4vY5m+7cvsDN1Ux9Se9p+X6V9qVZHVYfi9aGWDR4KfC66uUWQMh
	 iXB1ulNg+V/EBG/xU43ZUUuiynIuGX8MyVLLr79HS9aKCj7YM1HywidoGq+4rnCueUNLV
	 aJSnHAGt3gr/R0yGaVBivKvfrr3dJgW3gmGucG367beQbPqaGTXwxStmiI3rXZmLW5XId
	 81fzNisTEWbJoovOvgZBhwgjnd7WsQZLqtyTslflFhT0I2mxNEp1PSAZBrMknRL9IbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793979390;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=ofV2qVpqrfBMyd1/zLMm6/WPtcgEV4myUPpyNdz12kw=;
	b=L2+TettnGGEqJ4Of4NIsA35qsxUwmEn/x/+pg+t77pDg40ZbQYYyGQZJ9CYvxwbnF4Hg
	 bhWTLEMOAhXNuMgsIbrUheA9Qwd0i2B0+3Louoi0PKZcA+szDY4mB5aWU5N7U4w2S4Cz/
	 eGNnIUhH8m4WBsZDwavpIaZyfiyq7MkW9hIA6kukTXY6a1vwNcsQR4wtjZt/rxlkbkzkd
	 64K3ypq8la4SRiYmgJYsMYUNhr6sdZrXtsKHIDt15Y6sRgd9NZDD1ngS++IaFnXyaKgNo
	 FBF0FSq1h7kPLwL9DcexXfjTJWlHlvQGl1WBF6rZ1uj8ASQ/takGJIKK0DKr+3PCMwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Y+ng2dEd;
	arc=none smtp.remote-ip=95.215.58.146
Received: from mta1.migadu.com (out-146.mta1.migadu.com [95.215.58.146])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DABD606A33A
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 15:36:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4DABD606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Y+ng2dEd
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ofV2qVpqrfBMyd1/zLMm6/WPtcgEV4myUPpyNdz12kw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793979387; v=1; x=1794584187;
 b=Y+ng2dEdi+zky1s1Z1rLDGIGS++Hq+vKQzVnVV3Bm7feiPr8ZGdEVZLuhGimil0MsxeWJdku
 Wv8tzSO6ymkaR2N6WAWSeB+tJL2H2bE8EjQI59BI4tuYJoXNOvchg1zOnOcmtfqtnen4V3tmW5z
 gLZx9KfuxZJeOA7j0GJZGBC4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 9823a6152f062be6;
	Fri, 06 Nov 2026 15:36:27 +0000
X-Mizu-Trace-ID: 9823a6152f062be6
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5bfca2a2af4so814e87.1
        for <kvmarm@lists.linux.dev>; Fri, 06 Nov 2026 07:36:23 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBy7RpDd1X4aIPCANP9bJoHoChefsFNeJlJdMLeeJusiCq4AU41t1TT8zVqJ4kgmjD2F8YtKHSI=@lists.linux.dev
X-Gm-Message-State: APuU4Z88dYqt32hnxc1gcklwtzR5aOpsA5aeEA3Q06f0XVurJUZG5IGa
	HfLShdLw0LPqN5mbV0WQi4v3+xnNSkfUY2i0wo85F+Mv7dvbEHffxcXRGmV/Ng6LiIUdTFaaefI
	IBaMbwmbvMTIK1MutRcxxXHvx2+JRhZ7am0VYK1E/
X-Received: by 2002:a05:6512:1056:b0:5bf:f81a:f24e with SMTP id
 2adb3069b0e04-5c00a413bc5mr6933e87.10.1793979382196; Fri, 06 Nov 2026
 07:36:22 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261104084842.132944-1-fuad.tabba@linux.dev> <20261104084842.132944-7-fuad.tabba@linux.dev>
 <au3pNFOMeIx2X4Dp@e143914.arm.com>
In-Reply-To: <au3pNFOMeIx2X4Dp@e143914.arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 6 Nov 2026 15:35:45 +0000
X-Gmail-Original-Message-ID: <CA+EHjTwMv8NZvTy2cVtGRLoHxABZiv7yYUdRBHE69ieFUxoRXQ@mail.gmail.com>
X-Gm-Features: AclHuK_ZZQXxaDxpRQHq7T9rnG0s3OxixfWJ81iGmmqdPNJp-0OMdSXL2rZvnds
Message-ID: <CA+EHjTwMv8NZvTy2cVtGRLoHxABZiv7yYUdRBHE69ieFUxoRXQ@mail.gmail.com>
Subject: Re: [PATCH 06/16] KVM: arm64: selftests: Add protected-VM library helpers
To: Joey Gouly <joey.gouly@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Quentin Perret <qperret@google.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 6 Nov 2026 at 14:50, Joey Gouly <joey.gouly@arm.com> wrote:
[...]
> One minor thing below, that could be addressed or not.
>
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks!

[...]

> > +void pkvm_run_loop(struct kvm_vcpu *vcpu, void (*on_sync)(struct kvm_vcpu *vcpu, struct ucall *uc));
> > +size_t pkvm_host_locked_vm(void);
> > +
>
> Could add a comment here:
>
> // Called from the guest
>
> As you have those 'Call' / contract comments above.

Ack.

Cheers,
/fuad
