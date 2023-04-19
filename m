Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56A228F2
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 09:48:18 +0000 (UTC)
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-2f917585b26so2541703f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 02:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681897697; x=1684489697;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VUmNU9fmEDH4AWgVCWAPUoxIWc9FWYtply5fLTTOakk=;
        b=aFgzvnN2KDaOnk1PzgUfVwZs8/lyWRaVWasJExSE49m7XS88YM3b8tzP5OjITgwzTl
         ED5aLnGFxu8LwU5hDMrZKQs9m8ZAyGJPD7CBw1fL9KH5FaIasCtEkjiZj30Cwk1jMV2d
         7AK6ycFPsr9Rc+HnQ7e4MatP5xOlMDmApi07UZGvPlPN00B3n+zeGaX+Sgn5Ml37M1DU
         YNruLPHdax11p7FRSwuiloiC2g7kDu/nYwGbkElL3CqJ+d91hihnamyVqB1tVmduQwyi
         I0LIrU2Nh64wAL1V/XPH8HQOfSWZRjvqQ6xsvnsHC77iHuhIKQNRNtRX7Pqpedz8g3zN
         Fo5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681897697; x=1684489697;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VUmNU9fmEDH4AWgVCWAPUoxIWc9FWYtply5fLTTOakk=;
        b=alEC8tzWgPXtX6LU8YK6Depjt1vXosKyq7ZmgSttbIA8CpErQ6MsxAPxkChU5g0Yih
         v8ZMM0R9SpCL9xTghbNlXrYEu5Wq246jzkHyepCTIwV0qe/4O1/dMAPoIWEHR7D5TAiY
         nVYwCO6q2iXs88HhqImNOO9iSXInQvZGJ2JXGrAfUOuxpGydIqZLNt0ZgtDp2na2LW/d
         q/hE1fAJbhvP9yEqteon92koZLflxzeh/81yauCmubeJ68V6q5AbiX0iYYRu/kCa/1Ta
         Josqn7t+ukiSlMa6Bxk19yPnRWX+xo3Xh0Olw3yArmw6DD44/T691yh/GzJSHH3Tnfk1
         E1Aw==
X-Gm-Message-State: AAQBX9dllhy5gRsWnXcl1mMk6E3D5mvG35uYv9Q0G2s9EhR1dl+EBwHG
	5sePSr4zqMz6aj8XlXN0TKyNig==
X-Google-Smtp-Source: AKy350aRgpPx6s5bC7jE3+Xs1NiiOrq+N2HezetkWhWoRtt+8BQNsgxqVCUURhojJYFWSZlAOKqD3A==
X-Received: by 2002:a5d:4b49:0:b0:2fd:98a8:e800 with SMTP id w9-20020a5d4b49000000b002fd98a8e800mr3620146wrs.7.1681897696941;
        Wed, 19 Apr 2023 02:48:16 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id q9-20020a1ce909000000b003f177c3672dsm1599087wmc.29.2023.04.19.02.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 02:48:16 -0700 (PDT)
Date: Wed, 19 Apr 2023 12:48:13 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Steven Price <steven.price@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix buffer overflow in kvm_arm_set_fw_reg()
Message-ID: <46ace8c7-c3b1-4e2d-8af0-3f0ab1bd55f5@kili.mountain>
References: <ab7b9caf-5c90-4616-8517-b38637293639@kili.mountain>
 <d6e45332-0b91-2400-0549-068ea72a4482@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6e45332-0b91-2400-0549-068ea72a4482@arm.com>

On Wed, Apr 19, 2023 at 09:48:41AM +0100, Steven Price wrote:
> On 19/04/2023 09:06, Dan Carpenter wrote:
> > The KVM_REG_SIZE() comes from the ioctl and it can be a power of two
> > between 0-32768 but if it is more than sizeof(long) this will corrupt
> > memory.
> > 
> > Fixes: 99adb567632b ("KVM: arm/arm64: Add save/restore support for firmware workaround state")
> > Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> 
> Reviewed-by: Steven Price <steven.price@arm.com>
> 
> Although there might be something to be said for rejecting anything
> where KVM_REG_SIZE(reg->id) != sizeof(u64), as for smaller sizes the top
> bits of val would be undefined which would require the code to mask the
> top bits out to be safe. Given that all registers are currently u64 (and
> I don't expect that to change), perhaps the below would be clearer?
> 
> 	if (KVM_REG_SIZE(reg->id) != sizeof(val))
> 		return -EINVAL;
> 	if (copy_from_user(&val, uaddr, sizeof(val)))
> 		return -EFAULT;

I was thinking that zero might be a valid size?

regards,
dan carpenter

