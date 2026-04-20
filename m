Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB39B3C8708
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 14:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776694843; cv=none; b=rA3SyONKO6U5UFbVDXz+LkkbSTsrMYp3HCEICY9oP3Q65vAAeLw75Q3mblv1XDNlDUxbC8M8YkuaRh/O0A2AQO+87GwEAg8IsHLTxq0T24KoVCLJBxzpong3lpc6qXyjJdeWZhhgZvcye2g1fwBLlgZrq+bxpELwgIj2txcNVI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776694843; c=relaxed/simple;
	bh=2KVxJI9ejeEZMIbIF08+ol9mi4y5S3ApoE9rL6Bsf/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c8i06LXy4LaE77zJS+nkukr7CsoD5lVon5Srgk/7dmB5CnfuhXe60abFN8wA2h5f/A79OLyjGzwo+tWLoUgh/fLgp8kACBOCuKdEFZOjaBQxp55dz4dvk3/5Kp2Uo8ePwe3asQPDYnXyfNig6dLuz8gFFI4HGV+BFiDTlgmnjYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZeqpjvT9; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZeqpjvT9"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4891b4934ffso97395e9.0
        for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 07:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776694840; x=1777299640; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9ReL9mAV/3BRJ2Kkh/ldlZKgZcqKVBFpRWFlO3tSbuI=;
        b=ZeqpjvT9HDJItKiOkb3fUAXSwofvVWBIbOPg7qJOHeMwYJCgPwIjtXwbzXm76ziJ9i
         qohyfnxVFOaGKIse0jvwdcs1dxAD+Rb7oPhLZA/yirYxgN9KE8XNc/UnfK4NE0wxbCZT
         EgUR9QXo7aj1F6hqae08bSEVciBdOFjPPEzSmI4MDnyCWAV6e1Xckc9riYy58iS3ZfBm
         gouQl3VWXwWpQWtJGumhofnnHZ+TSqTqV9v3D92/uxK6pfO90wgfzQcLZBdtQfBkE8MW
         o5jG4OQLqyKFxttwj3P1flEjg1B2Fi7brenBFzgP28D+B87rwW/UWyG1PvHMRByMtjYH
         EVaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776694840; x=1777299640;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ReL9mAV/3BRJ2Kkh/ldlZKgZcqKVBFpRWFlO3tSbuI=;
        b=rIwA4uT2bVmCfr39zJi1YDPrcHCIaXLXjyOpG9sB+y92C3Y5nBmDJ5u/bbVIJi71Gd
         nI499ntifEthC9UAvSSEA/bmLLDGJvsJ4h/oNwj5ynRYOZNeLDLseDQ5+WyAY0/LbwZG
         nDIYMWQFvzFTUt0HjuXZnp4q/BxnvZjxOFb1CjNVnouTTQSs+Jb5VLpRMYIrUkFgo4TJ
         UWH63eP1y23M9ihfOohATq2ieUtuh/1DvJHnNntlsaAzzdiAdUJGycWcOvHup3y5nAwk
         OXLE+3g4buUQ7THjOomprpxP809fUPB7nVzJVPXSctkUI7AXGVNuCdgziGMxLpovbdYg
         LGIA==
X-Forwarded-Encrypted: i=1; AFNElJ89+WX9SrdlwkMqdg8u1zuMpkVw88HiOAePNly3PmQOihcVpnO3q08BApvtSGZvCkqVu9/m7zk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9XJdrHwNwv/i4UM6YUPsJpZztAdvraDwAi/1K0aWv2iOQWhXd
	9RCZacLaMisRpt9oMxUJcYjnZs7MKxxVikSOp08NEZgvL3q/KnC1/0A7iAe+D/dBzQ==
X-Gm-Gg: AeBDieuVfWQn7wRg2xuiJNfhtPbu4exGnh5MwI2gFY1EBqJkn0wDCgfIZeTSzDW5lXy
	Y4iwDIfsecGmMupKsWfOaLCX23RxXdf5/SqdD+4mlYTLx2BnjVJMoxo2BAHr3/4uIc4ELUUf75U
	lBpiBNLNwloqDmGm2YTruKeF+6j439Dhr0vu+AfOpE7U62PshVRz+kO0Z7sWGo85zBdgxFrvdN3
	czyTJesE9RuLHtguDjpBzuQjAGuDOwpQoXBsCpw5sSodxf6hybOqFp1WIirbYWit7J8GgVKLDR/
	dLb6NkeJvMRf+IN7Op8QQ8zOuuZTXvlqY1pi7Uezm4ZpQg6yhoyX52a+jms5Hygmfko1JmdUkC+
	YbNBTZlXrD9X6V4G4n8qo+SyVJiaUigEhLJ0wX6sylXurwzdVMHPfY3dGqoSGRDTaIWCYJ87if5
	PsDGBnEimcyyqUqo/tgpQpWDEpVP/DrjjaWryD3StjHahPO4dqIMoPuK2muVmcT5WO76L6DGuh0
	AqyyztgSnjvr8B3zTc=
X-Received: by 2002:a05:600d:848c:20b0:485:4133:4021 with SMTP id 5b1f17b1804b1-489013bd634mr1619625e9.7.1776694839891;
        Mon, 20 Apr 2026 07:20:39 -0700 (PDT)
Received: from google.com (117.15.199.104.bc.googleusercontent.com. [104.199.15.117])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4891c318636sm86355285e9.7.2026.04.20.07.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 07:20:39 -0700 (PDT)
Date: Mon, 20 Apr 2026 14:20:35 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	zohar@linux.ibm.com, roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com,
	peterhuewe@gmx.de, jarkko@kernel.org, jgg@ziepe.ca,
	sudeep.holla@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org
Subject: Re: [RFC PATCH 4/4] firmware: arm_ffa: check pkvm initailised when
 initailise ffa driver
Message-ID: <aeY2M3v97c00JjFe@google.com>
References: <20260417175759.3191279-1-yeoreum.yun@arm.com>
 <20260417175759.3191279-5-yeoreum.yun@arm.com>
 <aeYbdmshGZJ4GhXd@google.com>
 <86mryx2408.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86mryx2408.wl-maz@kernel.org>

On Mon, Apr 20, 2026 at 01:46:47PM +0100, Marc Zyngier wrote:
> On Mon, 20 Apr 2026 13:32:32 +0100,
> Sebastian Ene <sebastianene@google.com> wrote:
> > 
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
> But relying on this sort of ordering is just making things more
> fragile.
> 

Thanks for letting me know. Since this is not a solid construct we will have
to change the driver init code to come after pKVM in this case.

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
> 
> You do. Without the finalisation, SMCs are not trapped by EL2.
> 
> And even if it did, relying on such hack is just wrong.
> 

That makes it an even stronger argument to move the driver init at a
later stage. I was relying on this to trap early ff-a when the
ARM FF-A driver was used.

> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

Thanks,
Sebastian
