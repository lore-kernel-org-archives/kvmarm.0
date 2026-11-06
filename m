Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.139.74
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793975521;
	b=jcKs46eBKEjzfGp7w7YTuidoYqE6so5xIxgX1l2Z41i4f8zb3+HIFYWssyOxs+6Z9PYD
	 keqA/wurI8VAAfHgt0C/iI9eV+Brq5/DbUt8RxuUX5WI0S4mZTa1mk5krtFu3VRefHwQP
	 ddHeWCXGOqRWDL/8LX9CkQarJ3vhdFtmpPw4+rG9cVDdiZMWyVN01793lU7FeP0fR9AyB
	 b2qeAquA/9nkre7D/w1R+nb9+93uWvJcCkEwJ7SNXmHwCSyFH3uom/0NDDbmtMH6DuVB5
	 VsAglZMy3LoIU96Lfyd92Zfje9cE6EUhB0EJJgw444wqoDDq3HdL49hFEgXxBqx9rIw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975521;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=msHDOlhh2/6dyJiFjHesX8sOG3GnrS78AZnmwfxUHak=;
	b=uIA92cNjcUhjLh7al63TOos9RB+DrsWSiulUEXiwhBXDLvhSlBfR0wuMqwGtsoHDmkQz
	 muoOThVxfUEoSKI/o2HPCGdmEdhveXiwVZbm7dySU97mgOt0rtZ14qj2gjgOcsiUvqIZ0
	 JLzdUCapJX43Fepiwtd2HNssLVbgaJnHCwv3F2Q9Ztmk3mJ+1nr/BfSKkuxP2ob3EEeJo
	 O7oUBOzy234wDMwIikn49VZm2mK2q5JXBrqHkUDNfkUFiXSoaySEMAuoSTnp4tpZfPhRM
	 zSShMoqpHvGuyDlBmJcMqja0mYiH2KcxSLei/ahEtRoOnOVd6byK73tmalNQ20Sb7rQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=iPjHFPvp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.139.74
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42F8606A335
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 14:32:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D42F8606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=iPjHFPvp
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A6DcPGB1890444
	for <kvmarm@lists.linux.dev>; Fri, 6 Nov 2026 09:31:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps01; bh=msHDOlhh2/6dyJiFjHesX8sOG3Gn
	rS78AZnmwfxUHak=; b=iPjHFPvpRjHes5nIOyyVmq7NSX691jm8bNDgFCoF9S9Y
	tC1DdpyjGVI4thxa6jzkfettF4V1aJBLZ9UGeW8JC2mezZkM6h4cbcAwkBLCNdRs
	EQPMdh5dX5crv5f/0Nb4m12uU9l44F9i05au1GyWEhiGSAvQmvC4I8M8e3uOfO+k
	38GDEWbNgVJgde8UZtO2GcVzWZTYLKmQ5q40VM2xmyncNZY5MNg7aubjrBW/O0vN
	5c5QvLj9edxTKe3Yw5Q5+b5R+j02RocbxarAb+aJPFjPXXPFP37kiYVNo9Fu9Irw
	hndA4NLeqAOFQKISzprmic9DM1Pre5CkAVIqGWbGFw==
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com [209.85.128.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hs3pc3esa-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Fri, 06 Nov 2026 09:31:59 -0500 (EST)
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-8b3523b6a9fso1004647b3.1
        for <kvmarm@lists.linux.dev>; Fri, 06 Nov 2026 06:31:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793975519; cv=none;
        d=google.com; s=arc-20260327;
        b=jxyWdEdzYtw9jnh33Eizia1mCxgkYAkw4tYviIvehEru5AoQVn/B2Ta4BscZOHUcPS
         8yOfPQ39xJbs7OK4UWtkHneaUVLK5TwXYXcFkewN/kSfFvjXZGRJ1kXygSnwK2aXz7x3
         VLPBTqN6FtJCecczowyzWRskrz/s2KzvedQUn/iyxVRwgbvQ96Chhs8zJHAcQOYFR6PD
         sfea/wVqiNMaaG0gIOrCamcnk7z7Au9F5h6uNCIFjkL4lN29W1nDli/qeTNNIgdcEhMG
         BkVFurYGqLvwaELPhYaqL9oAo+NfyLWcos+idF1DtmUV8K9/0Y3Bq5appKjvyMaWVKfn
         m7EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=msHDOlhh2/6dyJiFjHesX8sOG3GnrS78AZnmwfxUHak=;
        fh=tebbHiQ2iltePDB/jyJMrxQRlCceCspo6pwAIbjv3x0=;
        b=STS88UWIxCx+F3AYGaj5cCokJkPoS+An7JHVkgyDHXrmOXEyC0Fpe0hq/kOipQTXe4
         SrVeZfktAADjNQ248ufSyPh/hYzZZCY+H5t+P8pX00R1A63bNyvYi8QxSgC6gJGNE2Bb
         MhSywHsyqD2uh7l3YPrg4svz7MAstDjiHInnbO9kV1LSfHOyocMSceJIzizLkCr0fHus
         zpsJrc/7FL1KqQ6tRefPMQHhxUMmaMGR2FI0WUnRFbCu5TTik+R6D6CiZXfqFflySBmS
         aIMmR8QiaSj+dUGT7dHsePDGUw7m9BdsdGVy3PHyznjuJmRfGOZOwsrj7T4dsgOJjja9
         xt9A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793975519; x=1794580319;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=msHDOlhh2/6dyJiFjHesX8sOG3GnrS78AZnmwfxUHak=;
        b=onfOc7iXxvRCyU2lj//TXRKmtTOwZwUny12dIIjvvSIcwHA52TMLAeyqJHiOwXnShS
         HDD2oa0XtvVDiPK1jS+7sTX6j6ke51JS/RrIGal0ITYG/R0BefeNYY7pxSSVxHAeZMHf
         uG4cGlQP5zRx1PAhRkZdlw9OWLtcPnqm3ZkceMM8jEFzHQk67uOI0UntGxvQSFt2V++F
         YtGNldfI7yhAwHj89tK0M0MsIJHjFaDzPDiheXIBhjju0sXZV9OAkMwRTmfvUfBBN16H
         aio/8ypgW+wZ1v7mWnJ9yuKJjz516MqRBqsI7zg44RDxQAFcBM+1gIIRE79Kf2bZ2sXR
         F4+g==
X-Forwarded-Encrypted: i=1; AL+hErFUQdZQHKJZzy3qenOU2+Ga2NH99e46CTeAGkKDeMOa/Fe7MvZhWDKGxGpNUF3Rx7//PNeifio=@lists.linux.dev
X-Gm-Message-State: APuU4Z+VgwmUQL7s0Fjg16WIQyGUn4ln1sPGkL7F9ZJVoChZ+KZkZoBx
	MgVJXWXmj7LgslxU2jBFbhdqSmvVMTKU7G6sUtjabG/XRF6IUN7s1KLhXPbdcXpFTTW7G71O9Qx
	m5bdaBwe2mD77VLnq9I1HWlDxL1yNy5rAVWtEdZ9sMFSCrIQ9HLO9WkJbt63e4bG84r/jjhOaeU
	AAOdmZA2aguq4nuS2z1Cn4h+9cqXL0
X-Gm-Gg: AYBFou1MlAzm6ECq+E9bC9GBIxXqjrwVp4XKjse/fuqVc0vohPPDnkiAXOTRXoeS5ZV
	0M9roJ6defDA73446EREPSHlpQGAGGz/5AfUFsB8V4bDjOw0xlPAupO9Kukh8EFUnFfUtxemiFN
	M+L4B/RjtR/Sv8gpwgyWc0E47TkIPco73bkYLoGZsFhmVOGCON/rnuvSvOmS7bIWphzDBSC50ho
	6sw9RVXNNdg+nBcFVhJKkwHrBUdKPI2HafX3tQXBajApbtuzflhcZtS04+0UyQOvR8qmgunuRqv
	77dwTVqWDsUrEBWYzhCTtMD836SUns3OLg==
X-Received: by 2002:a05:690c:4d81:b0:8b0:e619:7047 with SMTP id 00721157ae682-8b341971c4cmr11926677b3.50.1793975519306;
        Fri, 06 Nov 2026 06:31:59 -0800 (PST)
X-Received: by 2002:a05:690c:4d81:b0:8b0:e619:7047 with SMTP id
 00721157ae682-8b341971c4cmr11925987b3.50.1793975517147; Fri, 06 Nov 2026
 06:31:57 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261105-hyp-pool-and-map-v2-0-44a6ca90190b@cs.columbia.edu>
 <20261105-hyp-pool-and-map-v2-2-44a6ca90190b@cs.columbia.edu> <CA+EHjTzSKwuu6L8f0-=1s2XakCXJnM-k89XpagcwjSx6LX6wHA@mail.gmail.com>
In-Reply-To: <CA+EHjTzSKwuu6L8f0-=1s2XakCXJnM-k89XpagcwjSx6LX6wHA@mail.gmail.com>
From: Xuheng Li <xuheng@cs.columbia.edu>
Date: Fri, 6 Nov 2026 14:31:45 +0000
X-Gm-Features: AclHuK_6RKpS_Z72WeT9xcGJ3utDDUr-1LVpo5TooayXqPvbsyqigVFTteqzmVw
Message-ID: <CAPOPQMBG2aoTW6grkCChFxnBt0Q_+BeMkTQkoCGS6xDbssY9Cw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: arm64: Check the host stage-2 PGD allocation
 for NULL
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>,
        Steffen Eiden <seiden@linux.ibm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-GUID: UASLaiBDHe5pjhowD0LJZGPAD-LP9NGc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDA1NyBTYWx0ZWRfX+67wLil7O62b
 h/Cx3S/mv44OpSjQRnQfRZCBXJDLxvjTPT5LozN92wEkS++5PA8pD8o9cqyq2pirDV/korCJq4c
 jmF79I5A3KXGCF5OXOVuV77WijYlTX1M0ezePM5PyVaULoXY3HOqXQQvNpzOpOVzee6RcUFBhSP
 /bK5LX1cE5saSZ4HfROxbCyFCC/RRWWjRUF0WumZc2mHpbu0ZxaUIlStfgl3FaVhYAAJPfxV0vr
 QDT+d04TVDF9pcwi9C2MQqojGSFe6DWJLDgcBrz8QKsGJgvBGFF9XhleqwPZ5x2Itkb5xOavcsn
 3aq4lh8YIrdK+TYNe5wCZHY9CMAhhgq8l0MX7z7XR9KnbyGbRjgpM4/tSZNnoGJ1lWNrQBo8HlB
 NKPlKwwtE72CnTaCIcPGP90xqqZoW6SXTBfIPOw252yypZjzYhvCQ9UznrIEP1NxktxCxVg72I7
 SLCKq3bT3w4IwcqDL6A==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDA1NyBTYWx0ZWRfX+8rMerwihRq1
 MQdxtpW+FKTpb7luv4o5h682MCmtmyh7dy43IagsGKlPpwSMi9sdAOkeLBvBJPOGN9wVI2e6SA8
 gnjhBNLp7NCPzfyHkja2RDnAi83mmhUE40kpjAM4yDrfwSUW2Rxm
X-Proofpoint-ORIG-GUID: UASLaiBDHe5pjhowD0LJZGPAD-LP9NGc
X-Authority-Analysis: v=2.4 cv=EeRd0/mC c=1 sm=1 tr=0 ts=6aede4df cx=c_pps
 a=72HoHk1woDtn7btP4rdmlg==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=b_WDY_0Zt3HB6tkVrE0A:9 a=QEXdDO2ut3YA:10 a=kA6IBgd4cpdPkAWqgNAz:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11957
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=10 spamscore=0 bulkscore=10
 malwarescore=0 impostorscore=10 phishscore=0 suspectscore=0 clxscore=1011
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611060057

Hi Fuad,

On Fri, Nov 06, 2026 at 11:39:13AM +0000, Fuad Tabba wrote:
> Could you drop this patch? Once patch 1 is in nothing reaches it, and
> before patch 1 pKVM init fails earlier on those machines.

Agreed, I'll drop this one. Thanks for the pointer to the guest-side
fix.

Thanks,
Xuheng
