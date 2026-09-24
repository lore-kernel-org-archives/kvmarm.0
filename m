Received: from mta1.migadu.com (out-238.mta1.migadu.com [95.215.58.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9833148DA
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 06:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790230153; cv=none; b=dUuWFjTXjRUbKeM20Xq15M1R9GgOZsZMt/MqbACDimXkYsdI7yoozSqE50Bho8aS6+rHCQGxoxV0GBlHW3wdf4A6bCgsnM1fNx0nMIGzwIW+L3swudSVyqpWpmXvUGGEhod/2p+XSGEIYZtNFo7Qrbqn1DkHWhaKnpJ76M1g4OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790230153; c=relaxed/simple;
	bh=XHpWqj04QFUErnLgPhyPwQH0c/whsMd8F/Sj8yIguRU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QbkxLE2Nw4L/1JK4QcUEVDc3lp9kUGo8HmwSi8H2fuMBAo+MykxsWf043MFWBWHfTqRHHZdC6S2unt+8oGP8lbOOQHjtBRMy83ytgi4JcArUqG3xYviejhp5FwlNnDCSXLI0iQ76dIMK6eL73+4rKw+9tvz39rdcPujUcMiY5GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jrbBVUTr; arc=none smtp.client-ip=95.215.58.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jrbBVUTr"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=XHpWqj04QFUErnLgPhyPwQH0c/whsMd8F/Sj8yIguRU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790230148; v=1; x=1790834948;
 b=jrbBVUTrnyx4B7Q1uZ/B/xMaYim+VacyJWZZ/pgdEbjKN2BX1Al+j2xQuJzwD4noLWYflPmj
 3IuNZV9f2somZk9NekfjJy8r1uYk3MG03pI71fGs1V24WxNzAvENU/Fth+1TepwINjrI53yil7A
 Xc8l1h+UaLIdBZrinrjXhW54=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a050bbd84744eaa3;
	Thu, 24 Sep 2026 06:09:08 +0000
X-Mizu-Trace-ID: a050bbd84744eaa3
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5b5e5aaf7deso5682e87.0
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 23:09:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwYHnCTtzetj0w4N7+0fRhPSKN2aNp2iybptVGgeiz/nGxCHo7slm4kCR4Wr9+DmCqxyn1yISw=@lists.linux.dev
X-Gm-Message-State: AFuF++kp0JXlDKy28H2DCZir0SCeRlAZIjUztm5J6zL7fkS2f35QBSF2
	IqXDl6EQzCotJzQghqmKtEzJBHwfYIPHrJ9vO7xw485MILWIzpYlye9gzAsc+E/8cuCMu7Ow8iy
	bFvYt4acNevfVEBhxx/jTKVT2LeXCe8EsYya25WtH
X-Received: by 2002:a05:6512:2395:b0:5b8:b502:9a76 with SMTP id
 2adb3069b0e04-5b8de5cbe34mr121752e87.13.1790230147200; Wed, 23 Sep 2026
 23:09:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260923-kvm-arm-prefault-v4-0-d4b0b4dfa8c3@kernel.org> <20260923-kvm-arm-prefault-v4-11-d4b0b4dfa8c3@kernel.org>
In-Reply-To: <20260923-kvm-arm-prefault-v4-11-d4b0b4dfa8c3@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 24 Sep 2026 07:08:31 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyPsMQ-p4uRpHEd5sabKZPV0nuQv0VdoPWy7PpLtUe93Q@mail.gmail.com>
X-Gm-Features: AclHuK_F7RRmcZYBgSNF-QK5bg4WxE50rqT6HjF75xbDwVFCBghG7Y9qfeVwzCs
Message-ID: <CA+EHjTyPsMQ-p4uRpHEd5sabKZPV0nuQv0VdoPWy7PpLtUe93Q@mail.gmail.com>
Subject: Re: [PATCH v4 11/14] Documentation: KVM: document arm64 KVM_PRE_FAULT_MEMORY
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, David Hildenbrand <david@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Jack Thomson <jackabt@amazon.com>, 
	Jack Thomson <jackabt.amazon@gmail.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Leo Soares Passos <Leo.Bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 23 Sept 2026 at 16:18, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
>
> Update the KVM API documentation to reflect the fact that arm64 now
> supports this functionality.
>
> Also document error values and arm64-specific behaviour.
>
> Reviewed-by: Oliver Upton <oupton@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
