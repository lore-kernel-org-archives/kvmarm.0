Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53569140394
	for <kvmarm@lists.linux.dev>; Thu, 11 Apr 2024 08:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712825532; cv=none; b=XAL1coF5FZW9Eit3H1iPNUPqK8wlpzZj1kjXpINRD3pl6Jaw3TOYUWUuEYGs11+nZU3oZpa440yBromtKVhXKkuH+EU2dwU+3Y6+6kQrIXshHUW92nJVhMy+iWQDY6eA1dLgVIHDMvHfZ5GGeDKHx2fqz/w0nRtQ2L8K8UHaGyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712825532; c=relaxed/simple;
	bh=pFn/mSbRjf0iy6p9eQifrjWfK/3Yqa/UGNvAao52vf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fv5oOrHaE1YhkUZtq1bwvzV6Va6OH57EEv3814sJgQ83ZycNV03eeowiKj+pQ5ERqh65wK6GVBnSIidytuuRzlMZ7H8OcM06U/JsqeZMCWhi29Yl6dDhmXfT7TfV/FurRy26PwG+ERaF3WaHCFa7GpbKdrj0kY2XiDvr2+DOjU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hcoLS9Y4; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hcoLS9Y4"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-41687826509so58415e9.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Apr 2024 01:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712825529; x=1713430329; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BmVuDao6rc6hBIHx5Ev3aZcNpyMOiHsa4Eq9hXFl4JM=;
        b=hcoLS9Y4BcFrjZ0ye1OVPrmQZFympk8j+8QHg0ScLjzzfPn4Ga3GPF0Ins35QSgb1U
         0f+vn/36yyu6Wr/OqmymtniiSKSrt1rAmO/krWLE/ylJFfHervRXh1iGYr2RpAYZLmpB
         j5zHwDahIXCfBbr6RLFdUtrQdUDbWKbp4nNPdyACi0EZid2gxkvqg59T+wt0Ur7Tb68c
         RRU17JwhCKvtrz0OJd2Otfm4Rc4jysNWl2vRIoNbzT5g+k0hQbRLzEd3zlM35zsAL1d1
         qxzhZKfhS0cEawanD6xX5kaK7N91uTVHegoxIolTmS9ZqSvScNctAO6/E7CC0oxY3LaA
         kXsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712825529; x=1713430329;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BmVuDao6rc6hBIHx5Ev3aZcNpyMOiHsa4Eq9hXFl4JM=;
        b=d43XbA//E62v6EHmWTyVjt+X+8GFE5P9b/PLh+G5icKETNOHSudpETy7kxexMGO54l
         jJE6oTXGsAYZC6wrKqQm4e/H25Ni6D2zh1kPw/Ye8DwYo+G7eYDj4VdpboSzbn+29HAi
         sjah695Cva4p2ZynZ20CUukfMmLcMUOBRCCGF6IRWbTGs4y2iD9YlJ1+C+QVH5yJRXU8
         R9Jc94AeU26R56h3Cn5evu1eURH9y2kXktTCK1RgyCYToy6FIAWu/R2IrU/DdU8DxicW
         C/xTHPF2yy65fgdVcUvLK3QzkBtof4t80yoeJwkxpBnkZacXvg5QWBH7BNmGDbw4+0CA
         rcFw==
X-Forwarded-Encrypted: i=1; AJvYcCXP59ee9vko0ACJVuRmfAVC1eKgTjyUbPMWW0bwTGJw8Ehvd+Kc6RCtT+obJoAyGeynEJkTLsftmW0bn5vNTEsGO84ZSfE+
X-Gm-Message-State: AOJu0YygoNIZ5fwpMSyc20ZmxETWms8RwDV2FitcLbe/t7Fpw6JlxTIA
	cm2XEg6GgiRTL93hmdhQ76RvEw9mFJCt/RsFY31yrMt2II8rVROsBPJ1Fm4QDA==
X-Google-Smtp-Source: AGHT+IEHyQAF1b0TC6DYctDGP2A1rpYsfzyhRAynoAl9y0PZ04YsPHHdl/c1/oosy8F6BWBGGSq7og==
X-Received: by 2002:a05:600c:3d18:b0:417:d7a4:2a0e with SMTP id bh24-20020a05600c3d1800b00417d7a42a0emr88682wmb.5.1712825528471;
        Thu, 11 Apr 2024 01:52:08 -0700 (PDT)
Received: from google.com (248.199.140.34.bc.googleusercontent.com. [34.140.199.248])
        by smtp.gmail.com with ESMTPSA id he8-20020a05600c540800b00416a08788a5sm4855277wmb.27.2024.04.11.01.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 01:52:07 -0700 (PDT)
Date: Thu, 11 Apr 2024 08:52:05 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org,
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com,
	qwandor@google.com, sudeep.holla@arm.com, suzuki.poulose@arm.com,
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com,
	vdonnefort@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Add support for FFA_PARTITION_INFO_GET
Message-ID: <ZhektURnNMnIbSJG@google.com>
References: <20240409151908.541589-1-sebastianene@google.com>
 <Zhaoz9E/sw6jVnci@lpieralisi>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zhaoz9E/sw6jVnci@lpieralisi>

On Wed, Apr 10, 2024 at 04:57:19PM +0200, Lorenzo Pieralisi wrote:
> On Tue, Apr 09, 2024 at 03:19:08PM +0000, Sebastian Ene wrote:
> > Handle the FFA_PARTITION_INFO_GET host call inside the pKVM hypervisor
> > and copy the response message back to the host buffers. Save the
> > returned FF-A version as we will need it later to interpret the response
> > from the TEE.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 49 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 49 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index 320f2eaa14a9..72fc365bc7a8 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -67,6 +67,7 @@ struct kvm_ffa_buffers {
> >   */
> >  static struct kvm_ffa_buffers hyp_buffers;
> >  static struct kvm_ffa_buffers host_buffers;
> > +static u32 ffa_version;
> >  
> >  static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
> >  {
> > @@ -640,6 +641,49 @@ static bool do_ffa_features(struct arm_smccc_res *res,
> >  	return true;
> >  }
> >  
> > +static void do_ffa_part_get(struct arm_smccc_res *res,
> > +			    struct kvm_cpu_context *ctxt)
> > +{
> > +	DECLARE_REG(u32, uuid0, ctxt, 1);
> > +	DECLARE_REG(u32, uuid1, ctxt, 2);
> > +	DECLARE_REG(u32, uuid2, ctxt, 3);
> > +	DECLARE_REG(u32, uuid3, ctxt, 4);
> > +	DECLARE_REG(u32, flags, ctxt, 5);
> > +	u32 off, count, sz, buf_sz;
> > +
> > +	hyp_spin_lock(&host_buffers.lock);
> > +	if (!host_buffers.rx) {
> > +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +		goto out_unlock;
> > +	}
> > +
> > +	arm_smccc_1_1_smc(FFA_PARTITION_INFO_GET, uuid0, uuid1,
> > +			  uuid2, uuid3, flags, 0, 0,
> > +			  res);
> > +
> > +	if (res->a0 != FFA_SUCCESS)
> > +		goto out_unlock;
> > +
> > +	count = res->a2;
> > +	if (!count)
> > +		goto out_unlock;
> > +
> > +	if (ffa_version > FFA_VERSION_1_0) {
> > +		buf_sz = sz = res->a3;
> > +		if (sz > sizeof(struct ffa_partition_info))
> > +			buf_sz = sizeof(struct ffa_partition_info);

Hello Lorenzo,

> 
> We are copying buf_sz but (correctly ?) returning res->a3 to the caller,
> which is allowed to expect res->a3 bytes to be filled since that's what
> firmware reported.
> 
> Technically this is not a problem at present, because the caller
> (ie the FF-A driver) and the hypervisor rely on the same descriptor
> structures (and buf_sz can't be != sizeof(struct ffa_partition_info),
> anything else is a bug as we stand); they must be kept in sync though as
> the firmware version changes (*if* there are changes in the partition
> descriptor - eg fields are added).
> 
> An option would consist in just copying res->a3 bytes as firmware reports
> (obviously keeping the RX buffer boundary checks for the memcpy).
> 

Ack, let me fix this an spin up a new version.


> It is just a heads-up because I noticed it, no more, I will let Sudeep
> comment on this since he knows better.
> 
> Lorenzo
> 

Thanks for having a look,
Seb


> > +	} else {
> > +		/* FFA_VERSION_1_0 lacks the size in the response */
> > +		buf_sz = sz = 8;
> > +	}
> > +
> > +	WARN_ON((count - 1) * sz + buf_sz > PAGE_SIZE);
> > +	for (off = 0; off < count * sz; off += sz)
> > +		memcpy(host_buffers.rx + off, hyp_buffers.rx + off, buf_sz);
> > +out_unlock:
> > +	hyp_spin_unlock(&host_buffers.lock);
> > +}
> > +
> >  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
> >  {
> >  	struct arm_smccc_res res;
> > @@ -686,6 +730,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
> >  	case FFA_MEM_FRAG_TX:
> >  		do_ffa_mem_frag_tx(&res, host_ctxt);
> >  		goto out_handled;
> > +	case FFA_PARTITION_INFO_GET:
> > +		do_ffa_part_get(&res, host_ctxt);
> > +		break;
> >  	}
> >  
> >  	if (ffa_call_supported(func_id))
> > @@ -726,6 +773,8 @@ int hyp_ffa_init(void *pages)
> >  	if (FFA_MAJOR_VERSION(res.a0) != 1)
> >  		return -EOPNOTSUPP;
> >  
> > +	ffa_version = res.a0;
> > +
> >  	arm_smccc_1_1_smc(FFA_ID_GET, 0, 0, 0, 0, 0, 0, 0, &res);
> >  	if (res.a0 != FFA_SUCCESS)
> >  		return -EOPNOTSUPP;
> > -- 
> > 2.44.0.478.gd926399ef9-goog
> > 
