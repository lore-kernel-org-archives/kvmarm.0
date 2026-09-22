Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEB45678E9;
	Tue, 22 Sep 2026 17:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790098307; cv=none; b=joBvT4Na35XoxG1yPcKhiVlVJlc4j+ZE93jYsmV3m00pv82XFExvAGoU8sANRL2nMkBD0YznX8vi6YiU7BaGTuO8ki4el9aqA/tZiECgfwUmHioSlBfRNGRLG/3+O0jgSumbVRaKqwD39iGheGI2VZHlueMD76GOKtWxtLM6LPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790098307; c=relaxed/simple;
	bh=DBGZQMQHw71fFKuufWjC788bXvFI2Rc4VkJqrwQ3xbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KEJ5yk4JjaiPam3iLTF29S7u44kD27DxEdGyKaXy6fspabgUPu2El5tsHgG10gaK7FMw8xWogAHN9kDFmM7PFB3MtdSVn6LYi8XIgNryFW5IrhDOv+COp05WWSWx2QkDPK9nI1uby6EF8rutEBUGdYDSUh9IPKNNG1NbfRtatrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e3bN9/Il; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e3bN9/Il"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24721F000FF;
	Tue, 22 Sep 2026 17:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790098302;
	bh=pU5MDTrWcIPn0f9bdi37/3G3L8QSWUVNbMpQbtysNeQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e3bN9/IlMT809Q8HNhWzBbshsNy89YNRI7T0pc1ajitGhILxYyiV98IR/ZSzJM8lp
	 CZI38mav8zQha53451wcKYvERML7esM1Yxop/8fbqA6r7r5aZW+qerhlbuDm/BZDfZ
	 /7TgtU8BOaElRXDXXaoO0piTUuQjVhQIEgdtbJRDfcBaQ0+ss2CrbTTT3l2xXmVNVO
	 v0UHqAr+pPOon07E45yUbrlCPQzXGTanAqhi9FcceO6ADqo9AxTCnbJqXX/d6SLyjp
	 2NP6u7BByvQ7WsFllI7WWRHl9pQM8jd4l/neE6SD31Y02FHkvV3ryeiz9e+xmUdHh0
	 nnl2rOwNAtBxw==
Date: Tue, 22 Sep 2026 18:31:33 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Randy Dunlap <rdunlap@infradead.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jack Thomson <jackabt@amazon.com>, Jack Thomson <jackabt.amazon@gmail.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Leo Soares Passos <Leo.Bras@arm.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v3 01/14] KVM: Allow architectures to disallow pre-fault
Message-ID: <arK7auq5X5TzViWO@gremlin>
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
 <20260922-kvm-arm-prefault-v3-1-787bd3bc7e3f@kernel.org>
 <arKxjsxuO1F5ExrY@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arKxjsxuO1F5ExrY@kernel.org>

On Tue, Sep 22, 2026 at 09:49:18AM -0700, Oliver Upton wrote:
> Hi Lorenzo,
>
> On Tue, Sep 22, 2026 at 03:17:55PM +0100, Lorenzo Stoakes (ARM) wrote:
> > +bool __weak kvm_arch_vcpu_allow_pre_fault_memory(struct kvm_vcpu *vcpu)
> > +{
> > +	return true;
> > +}
> > +
> >  void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
> >  {
> >  	int nr_vcpus, start, i, idx, yielded;
> > @@ -4365,6 +4370,9 @@ static int kvm_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> >  	    range->gpa + range->size <= range->gpa)
> >  		return -EINVAL;
> >
> > +	if (!kvm_arch_vcpu_allow_pre_fault_memory(vcpu))
> > +		return -ENOEXEC;
> > +
>
> nit: it'd be better to let the arch hook return an error of its choosing
> but in reality this is only going to be used by arm64.
>
> Not worth a respin on its own though.

Ack will fix up if there's a respin for something else!

>
> Thanks,
> Oliver

--
Cheers, Lorenzo
