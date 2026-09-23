Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825672475D0
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 16:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790182105; cv=none; b=WSz8dPgSzb3ZauB0At5dgVs4N9vdYvvQbPnBVWdwUtGeTRpKSRTR9bsNIxd533GVt07zNvO1G16fuMX6M6eTMm/J1E4TLCsrs2uiOll2/OXN3z5OP/a5VhEfMcOuI5IQV0NT7LXksbb8PHkbJvWQSYx08ueMi+S+AoXpwz1YneM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790182105; c=relaxed/simple;
	bh=CGiWjTmGXAl6+wWuNY52mdjGBRHixUk9gnSMpBDzaVU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fio/jWgeMlKL5XE/aKzrDmOWTxTxZfe5FKGR79WvMXiMUgaf2bYG7TwtL1FFYR20rJZmyBlgPOAulf2PnLPTgnE+i2VodFx3go87Jeo9wAIFH0XQP1DGLPG3x2G7By4xAzGkM5hbiwMb6z1EzCH72xrDUF4g5wPnWbwrM5WJcsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HwURI9u8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Za1S2Ick; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HwURI9u8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Za1S2Ick"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68NGTxox741346
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 16:48:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4GGpD9bCLKwKljw9siihHkGdhbEHAKmKaI5FQZgKfS0=; b=HwURI9u8gOqsxzop
	D+O0P9O7uAoodVx8vvTnFSrFFdCFGgLgCpPcV8vhfjlglXwwOTzGnkKFaxkC/ZBE
	KzXKfya286vL+1P9N8JySDE3wy6BG/elusP9Fgzp2Cw60YVKuxkWrkOedA1JBIiH
	4MnTe3LupfJ5deFFxg2KXb528bKGtmwd3T3Q1YvyHb2T/DQceHMfTevWrE0DhQ+w
	wWdGCRmLV+pIlJ7nEdfZ5XCYUCjXDDzqeBrWD3zhxcQcyRNajCmY3qyEyaEgcAyA
	pyuKK0MX4yCYcvIuF+liPrfF9DrP7C9sn5MGqHusXYj5hCZr4UKG0Cm5Rv6IJhnx
	oo5Wdw==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvfjsgyp1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 16:48:23 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39e087a17dfso1505998a91.3
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 09:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790182103; x=1790786903; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=4GGpD9bCLKwKljw9siihHkGdhbEHAKmKaI5FQZgKfS0=;
        b=Za1S2IckVtD0+kCEob3eeZEddVgmEYjyGiNkfLP+Np8jam6MC2XgcMvC2pf3E50tEv
         ovStXm+ujcno/DiGHSjyfrVgmQRCt5oCFMGXKM6mX+/AYq3cEaut7gT8Qdv801jBfLBu
         DJ4J7/0hhf6SYdTZLe98IgvOy4DxF0rRtXzJ9uGxbnhzYMOYpowU9Yv1VeRJZmlWIjyN
         aoJVXBAU9GAzjYSQmIKn3EEgl41k7l2WW0ewKW/z+DY3B7CZ3hz17ii9R+mk0wfKCzXV
         sltRl9ia8U9TF48/e/f9NvlRqzeQ0oREQynpoPeCDnWbvfZdCeQE9Boh5JOrUlod5EU7
         5a/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790182103; x=1790786903;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4GGpD9bCLKwKljw9siihHkGdhbEHAKmKaI5FQZgKfS0=;
        b=uF7vrPhsaJfexJh2g4SG/shjvEzRCEmPLbYKZDSBd7u5D62ihnMdyNjLv5dDQawUM3
         xSvIeS8CALeYofkkzIQze0+M1A/IvBHVvp+BRtL9UkIsxYG78MFpfdN5BNBfD3xVhf2C
         pZg5L8kVBbn0nhWqTnD/H3BsK1UXW1fXqVHxYgcsaCVJnFdaB/ZDLPk73dO9Y5JVfCqg
         LorWSLt2fRD+B5wtpshgIa5cMn5nFxD4KhIxcNjAhkEHPezV3Sghlw08GN6aeIbK5kos
         qp0W/CyOf3bALQoXVjn+/8y0c9eaql5nw7dOXrz7z4SW2tsJZDEV35dIdx87ZYsYav9t
         AEmQ==
X-Forwarded-Encrypted: i=1; AKwUvBwvYjltrmgjZQPX2Qb3Lsjtk+zr2eAqCeSyto8WXlwHTopANwiYiFLCA1lvMBFM2EdWjccHJBo=@lists.linux.dev
X-Gm-Message-State: AFuF++mhpu3ruI44zEkD69O86spTL+/aQcpWRMIvMsb4uodaMnPNwWM6
	T3k9Nxos0kIZi6sQ8NDOaNYdGEr/3l3pfszMcLx/u3HwQpFC0TPmjHm7nu1tBE2iYBc0MZ3mcZc
	cChKep/K5x0h9H68d5hst1fHUBw66BJvWTjG/b9me5GlTEvHob6VyBWyeNwg=
X-Gm-Gg: AYBFou3zoleH7HTG/6qcUHvRtSvENBWDeX+cY4anJ1Jy4+cQOAlaK15TdHNTy4XkhpU
	K4PNZuNgtQvtg54svlkGdMKLyi9CfECJMXQfzwmPr5Hb0of0pN27nt01cnOBBTh0V+AY9jtRNey
	4xMANfIbgfnKWjPZcDmtjyX7uYEuC7FOqwRCsgMPDD1VzPD/r8NRA035bhi9+Z7n2YFm31bVlMH
	W5pYBurxc238hac0MHuTNFdV/V5VUEH1GkXqrQns/LMQUKxHzRJPvgov/6yghCFvpELq8buKEx9
	aIlL7BHRbsz5SNLF/it1Ztlsy29rw0XGM+HPUzRT6Qp7lx9HuUKSHwIyMyQClhI7MWCatN02VeB
	gINgcB29qZdf3X9jNbVwcDbBAa8yXPCvVpgwHb8uZNKH+mZEWvqKryw==
X-Received: by 2002:a17:90b:390d:b0:398:bacb:1137 with SMTP id 98e67ed59e1d1-3a07e54a8e2mr3129863a91.19.1790182102983;
        Wed, 23 Sep 2026 09:48:22 -0700 (PDT)
X-Received: by 2002:a17:90b:390d:b0:398:bacb:1137 with SMTP id 98e67ed59e1d1-3a07e54a8e2mr3129824a91.19.1790182102520;
        Wed, 23 Sep 2026 09:48:22 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a096b8753csm10943a91.0.2026.09.23.09.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 09:48:21 -0700 (PDT)
Date: Wed, 23 Sep 2026 09:48:15 -0700
From: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
        will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
        aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
        joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
        linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
        sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
        WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
Subject: Re: [PATCH v19 01/20] KVM: arm64: protected VM: Handle user writes
 to CNTVCT_EL0/CNTPCT_EL0
Message-ID: <20260923094815.000026eb@oss.qualcomm.com>
In-Reply-To: <528f3c4a-723f-47ad-a387-6e6a4179c96a@arm.com>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
	<20260920212845.707-2-suzuki.poulose@arm.com>
	<20260922122542.00006868@oss.qualcomm.com>
	<528f3c4a-723f-47ad-a387-6e6a4179c96a@arm.com>
Organization: Qualcomm
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.51; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDA2NiBTYWx0ZWRfX+p4FO7J76kon
 3z7XmEmsmmbu7xmX2HmN3FPujmwWacLoG4iKpuUcSEL1mNLj7lFoR48DshiaufO2ko90jJz8qhP
 ZSevZa6U9NCFKKbNDkYzhybV3a/wr4v4+562u8G1PzoFPH5gRGYzE6PyTghz0GKfBafNInulZYS
 5ipUBtruECvq6osOToParSPmxmVZ5AQLD5rzFFsMv2WZr+qRrEF0fZ43QZryLj4CXT10h5TDs6r
 Ofgah6DD860VuZ7CoXr1PYYbguErTTWFueJLRV7cI0p3tkdMKbaEesdabnQ6CQpb/bmGI+dgOpZ
 HopJmIDIpQoN8XIUGHwdrLA2uHVhb29N0Ap92gh8Svf+a/f8QpIy3jGEut/D/ftKpKchmByDA4a
 olQ51Bv4gojhAQIPOzj8bcKrz+IEv0W+UbmJfexmzoTHOInkKsRBLTTF5TPu8bF4c0/abvoudx5
 jalT5If4DMCXoptS4/g==
X-Proofpoint-GUID: 6fO5IQlcB4_R5vDnOFAV7B_4erloCb-O
X-Proofpoint-ORIG-GUID: 6fO5IQlcB4_R5vDnOFAV7B_4erloCb-O
X-Authority-Analysis: v=2.4 cv=K4+3jCWI c=1 sm=1 tr=0 ts=6ab402d7 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=7CQSdrXTAAAA:8 a=iHHI45kYt6FPp7tEAR8A:9 a=CjuIK1q_8ugA:10
 a=iS9zxrgQBfv6-_F4QbHw:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDA2NiBTYWx0ZWRfX6tUjM5QuC8iZ
 J89aVdjDw1itR2Li2UtAif0ktuJHG7s/RhNDOqjOaDi4MpSKhNo++LUBqPs4TzXanedLICVHLJw
 ZFzG3nt0acMAmdK4EQ9H3G7qpzDn8to=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-23_06,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 suspectscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609230066

On Tue, 22 Sep 2026 22:53:48 +0100
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:

> On 22/09/2026 20:25, Jonathan Cameron wrote:
> > On Sun, 20 Sep 2026 22:28:26 +0100
> > Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> > 
> > Hi Suzuki,
> >   
> >> Protected VMs doesn't allow setting offsets for virtual and phyiscal  
> > 
> > physical
> >   
> >> counters, as the offset is always fixed to 0. The VM ioclt is filtered  
> > 
> > ioctl
> >   
> >> out based on the cap. However we don't prevent the userspace from trying
> >> to write to the CNTVCT/CNTPCT registers. This would lead to KVM triggering
> >> a WARN() in timer_set_offset() as the vm_offset pointer is set to NULL.
> >>
> >> Fix this by always "fixing" the timer offsets to 0 and marking that the
> >> timer offset is set in the kvm->arch.flags at KVM init time for protected
> >> VMs. A userspace writing to the CNT*CT_EL0 would observe success, without
> >> any real effect. This was chosen over preventing the writes to these
> >> registers and returning -EPERM.  
> > 
> > Why?  I don't mind the decision but telling us what was chosen is something
> > we can see in the code - patch description should give us the stuff we
> > can't see.  
> 
> I have modified the paragraph to :
> 
> "Fix this by always "fixing" the timer offsets to 0 and marking that the
> timer offset is set in the kvm->arch.flags at KVM init time for
> protected VMs. This prevents the access to the VM specific vm_offset at
> low cost. A userspace writing to the CNT*CT_EL0 would observe success,
> without any real effect. This is cleaner over spilling *_is_protected()"
cleaner than spilling.

Snag is over spill is a whole different thing and got me wondering what
was over spilling!  

Otherwise that works nicely. Thanks!


