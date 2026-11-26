Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795701889;
	b=R4TeF9gJJkH0zF93jSqLlKO/r3g5eQLPRYesvsM2Bcl9in2ptYYlG6bXiol8Whhw4s4m
	 qSBTVSfgh5jXFRrmLMVXRyDYvdOwohtlL0/4dT/W//3312qfnt1xv2xQR6R0SmhZx0RLe
	 ngVMtPAihc8+rU6UAKTIU0IYGln4OoluggvG/s175YCdmurbs6oqnm1ogt6kAlVnAkPpV
	 Ab2f8DPXZrYIXGC0vjuUrC8+dx1M60zejQ0gS/L6doB2OzUuw0V6hFsKM8oGU0/YScDuo
	 7uqpcrVJ44dkf8ICTSQuJf/MBAAaQXUqtnZYzbCDKwPrA+ynpHh7uEIDIlPnCPYJzCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795701889;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=ULOdJrhzU/wAffNTY82qW4SO373n9wxqM9z/O7l2caA=;
	b=CGXgzhonbHuvBXO79oGr6Dvw3ddt9E24gnTgujWa2k510mL9Xc851qgvwqnBmNiKMfVc
	 tROTcl8YSSgwvqwEps4mHZY9xCWo80N6XfHNTnqu5wdDA0cCGZr0XE+aI+ES4axOCtqF7
	 0VcdLCv/KAO+0vDaNB78P1SlOvnWSIJokp+M4+g86Jxca1h76UXzP3PdjGzbP5JxswZku
	 jUg7iF/V9AHaPrs/DgolGX8rx81304o2DZFbJ6Fvv8c/lyO1nenxVwW7lek5vePARHIzQ
	 3Fz7XgGC5kTdt1R2Za/4cu16flsi0mD4axhO6pAo+EWWoqG244n/I67DtfmPW4Wv4KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=I09l4ZDN;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B64606A321
	for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 14:04:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53B64606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=I09l4ZDN
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4bb64ef5a14so70162245e9.1
        for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 06:04:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795701888; x=1796306688; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ULOdJrhzU/wAffNTY82qW4SO373n9wxqM9z/O7l2caA=;
        b=I09l4ZDNcHtcyK8YRWXxxJpkIz2HzJvD0ODjihfffcmROTbzOKnrPhtCsumAhMuSFT
         INO0dDry+Gu53Y0W9UDUnvxKVbQxpVkU3NtgknEpFBw5PvcDwAuiveMlIgQIjiCP9zTF
         pAIyEhlUQ6d9Q/MzCGUEZYiaS1rh72wNZaFW4dWZoJU9o0INzvt6eTzDXKN8HmDUA1Il
         u8vnUdBCv7i1ZBDlaSxg0lWYLFcWmcKLbcps9QkNQnXIWeWpSJLvXuZXKD5xRHPW/r+A
         uixUuj3GR1bUq4KO8kJcMRjOkUoRKQ+Ok415i946+7QAY3l1uDNudPu9plWk5D+vxRxC
         LHmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795701888; x=1796306688;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ULOdJrhzU/wAffNTY82qW4SO373n9wxqM9z/O7l2caA=;
        b=rm2en4PaJLFDdpxajMJmyjmbciMySivy+I9MZcTx9sWGqyDmZtvaP7fm3lxd2ESZg4
         ip5V0zt+WR4BWBTheNMxci/2MhDxp8DbAkR4bfX3h9kL4+BBY2ppZt1+iOgMoHJa3/iB
         2kEqgdmb32CCn/9VxwD8iOBuOdowVWMpkdHIMbyHk7NXkxTDNoLeJxa6dEXQUuHrs419
         5kCIAtGwEBUw5Mhdha5gdCK3T9F8CqxGuk5Pr3UBSbPqZWnzVjE6IeKmNSx7sQq5F0Po
         KkHa/7+EauvLyUnHO9XT1c9q7YCSDS4p3N3N30mhaLE6D6iO7LkhP0xruYiXAWWQKwLJ
         AAjQ==
X-Forwarded-Encrypted: i=1; AL+hErFkyDu0tQMl3kzdKSpa07ccj6/GfOgl7/ira8RtmTQDNUH1VbUmpSGzyCHfh0SXMZ4mqbFTAfE=@lists.linux.dev
X-Gm-Message-State: APuU4Z8CA2G1AnRKJ7CqStEmQkvVUB3wr1xR1F1LfROhmqw89lmpD7k5
	A/4lxXaHNR98RZj4WpV7ROnnkX5+eziRzJAucYy9K9KwdR64lRzB7mx10eHVoG0iTJs=
X-Gm-Gg: AZFdTZdO6vaRxM2DgHFGn7ejfqHNZZE7msfuWXCyKBHLDPebLn9sQiwEH5Gi4vMY8fO
	jeW5T06n8u8nG9v5v2GmY+YSGnFH8+3OgzS9bAj11oDTTgEa4oOcVQAq1sviU9bU/4BLX7TZ2+K
	MD/mMbnw66LV4heL4e/136Bkn5tWIpImsxLUT69M3aHYiR++TsXQP541bUCTZBC/IwXaLNLqncv
	ADa7fhrQd/SI5McoZw0Mcd6tLk9Zoz+C+t9i/Lvmo0B5WRWy2zNBFrrsRnVKDjadww1vReLrjN4
	4x3j/Al2DSYOh+Uf7JIpI3GnRYwbcuIbNHtqXnB3utszAd0nk4hIAXKAMJlqR6nHLMPe7q5j8Rl
	GzCVxeYwxS4RX4GM5Y9K8wbcEmDTD1Cx8O2U7+CT6bSz3ioBlGXgWESPSeqW8JK0S+T086WO4e2
	n1iuKRqJm9sUINsgKcdvdd4bI8TS7HDJjXTYqKzxcd6Tm2TSzZcT4wDGhXiUYsIqOA27iJKNhpu
	Iz95OiY83ugJKNF327tMR3j2cWPrGpofdmeyZqJCspa5KAQV7tEeSCwH1UeLIgXpElw570WV+MB
	Iso/q2TDGo++8gYzkt4rBKLM57NnxTuRjnXjDF4C
X-Received: by 2002:a05:600c:8b83:b0:4bb:60da:56af with SMTP id 5b1f17b1804b1-4bb8893053dmr381871055e9.25.1795701887195;
        Thu, 26 Nov 2026 06:04:47 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884911e3sm736831665e9.6.2026.11.26.06.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 06:04:46 -0800 (PST)
Date: Thu, 26 Nov 2026 17:04:43 +0300
From: Dan Carpenter <dan@pereq.eu>
To: Steffen Eiden <seiden@linux.ibm.com>
Cc: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>, linux-s390@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>
Subject: Re: [PATCH v2 2/8] KVM: arm64: Reset SP_EL1, ELR_EL1 and SPSR_EL1
 when resetting a vcpu
Message-ID: <awg8e0zM2DL87AKP@stanley.mountain>
References: <20261125-double_exception-v2-0-224689d8a764@pereq.eu>
 <20261125-double_exception-v2-2-224689d8a764@pereq.eu>
 <sashiko-outbox-232760@kernel.org>
 <awam4std0Zifdn9k@stanley.mountain>
 <awan8mSx5cbzXzJ7@stanley.mountain>
 <20261126133744.219929-A-seiden@linux.ibm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261126133744.219929-A-seiden@linux.ibm.com>

On Thu, Nov 26, 2026 at 02:37:44PM +0100, Steffen Eiden wrote:
> On Wed, Nov 25, 2026 at 12:18:42PM +0300, Dan Carpenter wrote:
> > On Wed, Nov 25, 2026 at 12:14:10PM +0300, Dan Carpenter wrote:
> > > Let me add the s390 maintainers to the CC list.
> > > 
> > > I considered doing it the way Sashiko suggests but s390 doesn't have the
> > > __vcpu_assign_sys_reg() helpers so it broke the build.  The registers are
> > > not the same so, either way, some of this is going to be specific to
> > > arm64.  But Sashiko is correct that s390 probably keeps a stale SP_EL1
> > > across a reset.  The s390 maintainers could probably take the selftest in
> > > patch 8 and modify it for s390.  :)
> > > 
> 
> FYI: the arm on s390 KVM in the current upstream state has no idea what
> SP_EL1 is :) 
> 
> > 
> > Actually, never mind.  This can be done in kvm_reset_vcpu_core() like
> > Suzuki Poulose suggests.
> >
> 
> We share kvm_reset_vcpu_core() as well :) 
> 

Yes, Suzuki Poulose told me about kvm_reset_vcpu_core().  If I put it there
then I don't need __vcpu_assign_sys_reg().  Thanks, though!

regards,
dan carpenter

