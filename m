Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EAA363C7F
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 14:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776693932; cv=none; b=uFBPMXfQe71wYFZOb0won1iaNXn4w8Gl373majrIO4DrN79vMkOlpwtnxqCzDnhMFqkUi7MqwnLWhTEO3mSLx4Hsr1hiT2V7ykiMa9rkUznmxj3sYJmLNUBwejraabu7tuf3qK7dlwNNk1/q+lZrm3BPOOdH6zJPSz4b2s+3U20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776693932; c=relaxed/simple;
	bh=S2UHySE5XaH78WLFRWMsAh1zPx/419Y8+b7A7jvMIso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XpDEXWZd9ZCM3D5FvG3Vexf2G8HXd2ijMiLQqWMR56CBkoDBpYUZx1Z/0SejoN05/LrawIon9GEBzwSPo2BGSrJ4LCgz5r4tv6SWuYgaWM89s/KPnHplC4NJstIj48KuWQkkhO4pmT8ylbZGJoK9eBAtR6juXQLXfIjV7qBnyQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MrHXGr4e; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MrHXGr4e"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4891ca4ce02so94525e9.1
        for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 07:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776693929; x=1777298729; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G6q3FLtE0M6J2F/PfEuR3infOq1/jMGGhvYKqZy6+Xo=;
        b=MrHXGr4een1Cr34ECrBfevsIt7EMr6o4fQCCVH9IdPqZyFBy40nbPr7EQgkAfkS2Qc
         g7E63n3XKx1KhVRzo/imjNvGUc2LHqt6nglN5aauaouMbsageUou9+faBkRA2SP1A4Ie
         U0mNdwkJMiNW9sPPgw3wYv7RCYz5aaZgH4uLhvxM09KvFFtjnbsHrXxGk1DR7T2jKO91
         7AklJ5W8jbBqN1MwMqQ1KtT3iw7kpfIUP1pXiqPNnZVLQKf8lf9JoVnnFKEt8s/RX91/
         6EEnfF3NX5ukDUUqTJZ6qGHmZdrOjTsLNaEpX0yoWsieRxZSjEWjlwFzhIfHWnzG9pG7
         vH7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776693929; x=1777298729;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G6q3FLtE0M6J2F/PfEuR3infOq1/jMGGhvYKqZy6+Xo=;
        b=gWMI+xnvXhSJ0hfA6mDGs5A2UZ37qACG8KGWQQNvtKCzSj30J2tL4XUkqCN4SkMzK2
         lBrjLv9WG4zwxmOXg+7DSMcpxb7zcJa+qvygG2SL8c5Q5pd2yV7yhdo5pfA55XHoJbC4
         IwYtqVUT8Sj+AzQieuEz63s/szr+xZ0UXryfJggROYYM+OJYY2PliPaKQS/6eSAi8+f8
         32gSSOACL5Occtna1BP3cvahgYZI/m/IfVQfSYyWlvBG2bfoYPynS/JXac4YYYX67GX5
         LBkIQiwJi7I6MqoAmK+Ox/qksNT1I437OW/CbNmfXJGxo2TFopS2AxTPQ2OKkazeQdQp
         Tb2A==
X-Forwarded-Encrypted: i=1; AFNElJ/MLGFKyf22ybxKBT5xKtiphdle42HiTTeZ6vPUy3bsU+QoP+D/3ohduz00NSNlFMoYlZnibu4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwC52P8yAjX/WYjCtBorl3F1LzuHypRFmUob+rIJyMHEewnBHmR
	8Ijy+u1+QS6IuGSh/Bfvh2uX//7jTFo3rKa3rk9gWewigKiVKyqM9eE50n2HnkUhGw==
X-Gm-Gg: AeBDiesERlnpP8Jc6Up4lXWwaanJ5quakTUbEUXyPXOpz5YKsw/8DyU69Oi+R+JjU0u
	0/ak6K1YeE83+dEVgYJtjZ4UcTsxvvLPR4yUD2Sm+i7HL8AZUhS7cX7pggQaGl8f66i1xs+/hvz
	hkxR32ReXMEZCRIPJ/WAEFgifSCn6+9P9dpYoKk065bcMDZ244lcXcp7lqNKnf+Cu373NW1gmA0
	Ehcmnfi8mFvaEOwd6EnV64Gw+0EZn+DU3vOgpDjOk0eb+ksLrtCPN9YtpFvRV3s90B2eITbzt2e
	Vqo0Fpz4hjua6BQUPsj/LU9ZoMEJpNIiWUQaDBAIQTuZ9B5pBWclupXJGc4H3wx8OWJY4QREYvR
	271P8rL/5joEkeOV1A+AlpRsFr6jPxYnVVBApfB9FtCuLL1jegO65pKHxccbjyOfp1iQs2CpjJU
	bAPt+oT3F/3V7aGdMrEf5r+IGiGM/lDGzKUhbp82+g8+znkdmU1jLTwfmEHn82SuXAGSDXBB3ZR
	ReioXzVHUQ8awd0WOI=
X-Received: by 2002:a05:600c:55cc:b0:475:d905:9f12 with SMTP id 5b1f17b1804b1-4890095cc81mr2067335e9.4.1776693929074;
        Mon, 20 Apr 2026 07:05:29 -0700 (PDT)
Received: from google.com (117.15.199.104.bc.googleusercontent.com. [104.199.15.117])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e3a341sm32798494f8f.24.2026.04.20.07.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 07:05:28 -0700 (PDT)
Date: Mon, 20 Apr 2026 14:05:24 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	zohar@linux.ibm.com, roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com,
	peterhuewe@gmx.de, jarkko@kernel.org, jgg@ziepe.ca,
	sudeep.holla@kernel.org, maz@kernel.org, oupton@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org
Subject: Re: [RFC PATCH 4/4] firmware: arm_ffa: check pkvm initailised when
 initailise ffa driver
Message-ID: <aeYypF4lv6LMH2ch@google.com>
References: <20260417175759.3191279-1-yeoreum.yun@arm.com>
 <20260417175759.3191279-5-yeoreum.yun@arm.com>
 <aeYbdmshGZJ4GhXd@google.com>
 <aeYjiaPtAl7SMVkL@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeYjiaPtAl7SMVkL@e129823.arm.com>

On Mon, Apr 20, 2026 at 02:00:57PM +0100, Yeoreum Yun wrote:

Hi,

> 
> Hi Sebastian,
> > On Fri, Apr 17, 2026 at 06:57:59PM +0100, Yeoreum Yun wrote:
> >
> > Hello Yeoreum,
> >
> >
> > > When pKVM is enabled, the FF-A driver must be initialized after pKVM.
> > > Otherwise, pKVM cannot negotiate the FF-A version or
> > > obtain RX/TX buffer information, leading to failures in FF-A calls.
> >
> > At the moment this already happens after you move back ffa_init() to
> > device_initcall().
> 
> How? the kvm_arm_init() is device_initcall() if both built as built-in.
> 
> >
> > >
> > > During FF-A driver initialization, check whether pKVM has been initialized.
> > > If not, defer probing of the FF-A driver.
> > >
> >
> > I don't think you need to add this dependency. pKVM is
> > installed through KVM's module_init() which ends up calling hyp_ffa_init() to
> > do the proxy initialization. The ARM-FFA driver comes after it (since
> > pKVM is arch specific code). We don't have to call finalize_pkvm(..) to
> > be able to handle smc(FF-A) calls in the hyp-proxy.
> >
> 
> As Marc said, the before finalised_pkvm(), smc wouldn't be trapped
> to pKVM. IOW, in case when both built as built-in,

They are, I tested before replying to this thread. The HCR_EL2 is
0x480080000 so HCR_EL2 TSC bit is set so SMC/FF-A and trapping is enabled.

In __pkvm_prot_finalize it sets the HCR_VM bit which enables stage-2 and
then write the HCR_EL2 from params->hcr_el2. However I wasn't sure that
this is seen as a 'hack' and not expected to work.

> if ffa_init() is called before finalised_pkvm(),
> it couldn't proxy the FFA_VERSION, FFA_RXTX_MAP and FFA_PARTITION_INFO_GET
> called by ffa_init().
> 
> How can you gurantee hyp_ffa_init() which is called by kvm_arm_init()
> comes first even kvm_arm_init() and ffa_init() are on device_initcall?
> 

While they are both on device_initcall, the only difference is that
kvm_arm_init is arch code which appears before the driver/ code in the
linker. That's why Marc said it is not a solid construct to rely on
this. 


Thanks,
Sebastian 

> [...]
> 
> Thanks
> 
> 
> --
> Sincerely,
> Yeoreum Yun
