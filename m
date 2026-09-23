Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812723559D6;
	Wed, 23 Sep 2026 13:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790170422; cv=none; b=IDLDw0AOQ3vm2ItsTYqJAsN2XP+nz+QwfjDNactNwIHZ2MAj5dTX3pAXxJ4e6X62I9dyeIld7pztJtkybOQjD8OyTxfd4Zll1XT6L4VQwxzBc/o5HMmZQMljuKnhNqFcEFCvoeJwHltBVUrl+3gmK/cFc14DlVQEGTT0gQrRVOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790170422; c=relaxed/simple;
	bh=Glwn5+xNNEsiGY0AkWLewIKSP/1m9/I+d44zcE6ygYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T2g8Wtv5gcOP4finHlJ7S+Mz2TcIyyBjZudiGqYnLeF1A88Vm7uvYxT8xdsdpc+AM9l2lX1rpngUV1YNfg6Onxhom3iazQFxfO1Yk+GNCjo5oNyKMFW743ty+autMC/+IDr0Gs3wFQqNMkzyxb5sChSNV077aQhka+SzyVcqwqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BQ6057MT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BQ6057MT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60A01F000FF;
	Wed, 23 Sep 2026 13:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790170421;
	bh=Glwn5+xNNEsiGY0AkWLewIKSP/1m9/I+d44zcE6ygYY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BQ6057MT1zcOmAohcwlO4SiOTlts4xVonSVjO/LccVR+FZS4N6VWjlk6MwYOkHFp1
	 s49gevLrJSDqNTCBgen5O7jfl8Bz1qTaK9sgrXiPGsw9OxDq/kB9YC0j40MFb+MH51
	 10D9naFbsjdGXZrKvk/gMsN1Vx1dUX831H237Fqox+V7z5LtpPx/9TlUDWxAZ4z/sd
	 jTH5wsAYQv+bWjmqbTx+0ZpxFwnIoZC86MokSCNIqJDU+2PFyh+zdZyO1qxggPOFSo
	 sgS6oVXe4LpC4QQgocn87cUc3vcBVKb1/M5gx8TxlLEkI8UsMmxMDkM8xFFoo3cOkG
	 NZdaXS39paeww==
Date: Wed, 23 Sep 2026 14:33:32 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Mark Rutland <mark.rutland@arm.com>, Randy Dunlap <rdunlap@infradead.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jack Thomson <jackabt@amazon.com>, Jack Thomson <jackabt.amazon@gmail.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Leo Soares Passos <Leo.Bras@arm.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v3 10/14] KVM: arm64: Implement KVM_PRE_FAULT_MEMORY
Message-ID: <arPVH1z-Z6zzLy44@gremlin>
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
 <20260922-kvm-arm-prefault-v3-10-787bd3bc7e3f@kernel.org>
 <CA+EHjTyCc=T+HkvWv1g2Fg3OxGaa1i8Hdv296ivPc94jQqZq9g@mail.gmail.com>
 <arPTt4WuVxcdvThs@gremlin>
 <arPU4O4_oDUzPcod@gremlin>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arPU4O4_oDUzPcod@gremlin>

On Wed, Sep 23, 2026 at 02:32:33PM +0100, Lorenzo Stoakes (ARM) wrote:
> (Folded into 5/14)

Sorry 6 even...!

--
Cheers, Lorenzo
