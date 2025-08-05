Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F12621A94F
	for <kvmarm@lists.linux.dev>; Tue,  5 Aug 2025 19:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754422738; cv=none; b=RenG/tRVmmdonq0nZ17Kr5pRGRqD0AEgtJ4PHdCIU21uZERQlQv9+6ZfYOSwshLk7DQZEwGMpqlgm5PfGQ8ojckIEM+SkiUlHJ99T/osR7eioeXYTX+wr/K2lhi3L1hJRTtpr/9lCmkdpzCvQV6F1UFfax/yAzkwu0soVtWkKyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754422738; c=relaxed/simple;
	bh=d55My0lJH7EW7U+QyZ/8kq2QwJb2wcxt82jheLEtpaI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jp4i7RLNYaYA84N7bTZkmqQc4j4cFGAkdYEGDjUYpCgpY9ab1IN3Oml0Bq/RaRaxcTmmtB0Q5tMJMWkl8JXWyWk7tRPOatv9Jg+xbGoiJ0Y3S0kyiV8Q9iadV44zzGpgRKL8kjuPG/JIs5Sg9Zq0c7L5/c7nOiB8EnJQyjH7EpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Ccx5f+H8; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Ccx5f+H8"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7e344e0212eso29932885a.0
        for <kvmarm@lists.linux.dev>; Tue, 05 Aug 2025 12:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1754422736; x=1755027536; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WfLvHR5VGzBySOq4iOqpMOpGA+jfUgtajL+0K128VgY=;
        b=Ccx5f+H8ReLt3lgU9bpJStvviaId/5HbxJa/Gl/qdNQkF7MhocYljPtJQvDp9WKcBa
         AhOTBkdDZL4N3OvOMBIVq872AcJlT+Qg/i2ps6Daia+uILbGCSfmo3U/35Eggr8zh/zc
         ZhcIssU6sb8Qrem8G+lHXK5mfpHKIgt2Syq3rW9iBMJyInN3ZT8DlpZkeImdz6Hc/xvy
         puElOcc1b0tIXPtk2tHLJwm5hEDZ6LPxDKXhsDwYDZ5FxLPvcaKGpSzB3a+ynPFo18Z7
         OYW/z78jg4DNnzfJh+iLXkyj1Vm/U7ulRaUvCCCpXtsAWrzf43SqMkg360GSqAVtK1qS
         psmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754422736; x=1755027536;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WfLvHR5VGzBySOq4iOqpMOpGA+jfUgtajL+0K128VgY=;
        b=n89s5JGmXXIocnmGropEUuJckDwyVJx+/ViTISPOu1qDLzl821IpWAt6aLlkIm3H+6
         V9Bw/JD9LTWks36zHuHvXtkigYlRzoiABEJ24BxWVtSX5osQz/s9ij6ONkhNnd2yZ8aT
         9f4eq/+tHLxLdWPO5bT8HDdsjmYtvYupypqvQZngL5xXrU1pvFGzYtK6+BrHlIPusS7+
         vPNy6rhVVJqRnriGSVzNjeAV0EeNzFO6JBYPbKAakKBMhz5kndpNHVMSLhnujqjHNi7e
         OYlDkIqcCWkWAB+GU8iJDDdTOfzWYT+3o0mqudi9v11t0gQBO7APNWCFVuiLUb9EXTqa
         XE7Q==
X-Forwarded-Encrypted: i=1; AJvYcCW6P+yg0HJo9rF6wMJBaLE6TU0Is7jtHuHugQyhAcyOqQl8hWpahONp7uaU4mXXeGURA0dLAwI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyqXPBUsqJHH9E3afimeXgWVv7ZtOvYI+RcUJywkcWNzxQHEdRS
	gG+PsHwY2OiElo/1W84qU/vYD+kk89XOFnmYGIC1IhJOODuFfXthCQn0Mbo3reqjhYo=
X-Gm-Gg: ASbGncuGG7hfBFcbXzZTx85psZLsir4Wj7sWhzkpN+Wuyq0C7G6ZUDMhjVF2L9CWqeu
	ZHVVckBApzrQQktHMJqnDIrytyL274ObitfhJGJf+KaF+jqgWvytf1LQk/Tdub1H4q6dsO6Kjd3
	LGTRBih331DcqMoIaplv39ryIT7t9OR86gnHV9IdFyJ10WIs/mAfi1HzoKuZWY15tL+dect/15H
	P0Z7hL5liOx0b67yQc4PZiGfE/PMKhwLut7caYhXUH0Ov+u4t0Ylmlpk1sDMwQnSOMSsXTf/trb
	llHJAEeL/huEC97j/K7vkYxfjeqL7Acf8nKk6CezzLauNO2ardhDIDVBvHQo5jhRT11yHBpCPFB
	WY8a7UnKGDpjELqL31j14RQfILvRikZI/od0B3lpLIFW0ggQu8poZZWNuNhLa1kGSmXYlLVaTTT
	7C/fU=
X-Google-Smtp-Source: AGHT+IHKL5erm4l2X0vMQA58xzXa6BvQRyAOGPl1hFFlslB9qavE3XT0GkQjfse/P0NHo2ZevfOtfQ==
X-Received: by 2002:a05:620a:45a4:b0:7e3:3001:47b5 with SMTP id af79cd13be357-7e8156a5942mr24897785a.1.1754422735775;
        Tue, 05 Aug 2025 12:38:55 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f7064b0sm717749885a.54.2025.08.05.12.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 12:38:55 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ujNUs-00000001abD-2dVJ;
	Tue, 05 Aug 2025 16:38:54 -0300
Date: Tue, 5 Aug 2025 16:38:54 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: dan.j.williams@intel.com
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	aik@amd.com, lukas@wunner.de, Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH v1 00/38] ARM CCA Device Assignment support
Message-ID: <20250805193854.GA377696@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <688c2155849a2_cff99100dd@dwillia2-xfh.jf.intel.com.notmuch>
 <20250801155104.GC26511@ziepe.ca>
 <688d2f7ac39ce_cff9910024@dwillia2-xfh.jf.intel.com.notmuch>
 <yq5acy9a8ih6.fsf@kernel.org>
 <20250805172741.GX26511@ziepe.ca>
 <68924d18a68d4_55f091004d@dwillia2-xfh.jf.intel.com.notmuch>
 <20250805184219.GZ26511@ziepe.ca>
 <6892562356e53_55f0910010@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6892562356e53_55f0910010@dwillia2-xfh.jf.intel.com.notmuch>

On Tue, Aug 05, 2025 at 12:06:11PM -0700, dan.j.williams@intel.com wrote:

> > So unbinding vfio should leave the device in the RUN state just fine.
> 
> Perhaps my vfio inexperience is showing, but at the point where the VMM
> is unbinding vfio it is committed to destroying the guest's assigned
> device context, no? So should that not be the point where continuing to
> maintain the RUN state ends?

Oh, sorry it gets so confusing..

VFIO *in the guest* should behave as above, like any other driver
unbind leaves it in RUN.

VFIO *in the host* should leave the RUN state at the soonest of:

 - cVM's KVM is destroyed
 - iommufd vdevice is destroyed
 - vfio device is closed

And maybe more cases I didn't think of.. BME should happen strictly
after all of the above and should not be the trigger that drops it out
of RUN.

> > Yes, and probably not necessary, more of a defence against bugs in
> > depth kind of request. For Linux we would like it if the device can be
> > in RUN and have DMA blocked off during all times when no driver is
> > attached.
> 
> Ok, defense in depth, but in the meantime rely on unbound driver == DMA
> unmapped and device should be quiescent. Combine that with the fact that
> userspace PCI drivers should be disabled in cVMs should mean that guest
> can expect that an unbound TDI in the RUN state will remain quiet.

"userspace PCI drivers" is VFIO in the guest which means you get
FLRs to fence the DMA.

If we end up where I suggested earlier for RAS that a FLR can check
the attestation and if exactly matching reaccept it automatically then
it would maintain the 'once accepted we stay in T=1 RUN state' idea.

Jason
