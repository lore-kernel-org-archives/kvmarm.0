Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.139.74
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793975651;
	b=S/VsXDb+hBjx9WQK08LDzVRoou2bkDB4ivp29tNBiSf2zABax0kV0ThEYcDj30O85R6L
	 nKTVl2IYYpRET5f6/L4mE5wh5yDGybKN0dUQ7hxr2yK5q4gk0LoBUykKX4TStxZaacUwc
	 kot31YhEp0P+6PoDH6LKI5v5mX9Lslc6mWKB7i7gRgls2KbUnYwhtpumfpqpIBti5PBCD
	 mDU/lcdI/5uTnJifFQYNstemrIRL2R3iMhZb532FUCwfK1prsgZLTg/uz3Mc3okMCPFQS
	 NomxK8nWCbga34xPG+Q/kuji4ynz4v3uUD51xSQ8k4N7S8OICexRvQAa58G6Q12xbXQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975651;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=6NEDxCP1xlNVWbzDZl40x2kZVNRASxcVTF174olVpag=;
	b=veRZdkmNb8LEEb/fiVmW0xtYP8u4TStnBe+PShDNKBImzcBbipgtLM8eRWSlkqC9VWBf
	 wTX5g5++I9nBGDbBhqNJUuJiJfQZ4pLMMY/ydU38TWfZWeVPuQjdPCKiQ0bw2Cgks6uCG
	 APSlNP4iXXaDOWlRrua2fmG7RsILk48XCErMBJ/63rxDhhwRW+yAXixzt4QjPv9ntDwHk
	 zu4n7a8GJCZVEA7A+Byxu+Esmb9AqOVY0ph4SR1SMJM36jeOcZmLm93ZNpxvQ357r3afA
	 et8cbXafuoThh67K7tQkbkTNRlr51QkS+Fr3C75yMLghfswc/7ehOV9zX6iAt7KJ1Rw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=HB7KHfbr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.139.74
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D841606A32C
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 14:34:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D841606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=HB7KHfbr
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A6Dd79u1940799
	for <kvmarm@lists.linux.dev>; Fri, 6 Nov 2026 09:34:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps01; bh=6NEDxCP1xlNVWbzDZl40x2kZVNRA
	SxcVTF174olVpag=; b=HB7KHfbr/7te2RP8UOwHGzPddg5VJkjPEiIbnJKXxAtM
	/1arVxL+0OwLMHleTH89/y0TkcJrzfL2pcG7nqNuBJUuUWGO6Vr467BpZ5k+KRXh
	e4EDEr1vfgtpwAJGILC97fAMPf/yKukD3d1B0qULBP6FIgWnLBlVgoIavrpQZgmZ
	ql1N33Fw2cBBclJ2RFf2u9dFdxfH7Vk3jNKsgkEzkpINJMWLOJNLONnRiwf6sDvw
	QX8c99pRXGWpNYsgKnpWLMQoxskExW3Nyq83HtmG9WqgdOKlI5RvLj/WOtEfe9Mu
	HBSl991SGWtJoCHM3WMi40KDIJI25LsRXMSpp8dIaA==
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com [209.85.128.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hs3pbucc5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Fri, 06 Nov 2026 09:34:09 -0500 (EST)
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-8b2fd108b28so9076347b3.1
        for <kvmarm@lists.linux.dev>; Fri, 06 Nov 2026 06:34:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793975649; cv=none;
        d=google.com; s=arc-20260327;
        b=JUxamdOP+71D2ceuBPzuSk/owpvhQYWPVFgK+FQUO7QZEyHnPiKygKtlJ9hFO3FCpX
         k12qG7rBarHqysu0OHfV2gltJdvOWK1bXZssYTvOu4DN3RuNbRnELOKF1zAOoR24/uf5
         P8U9RDFyLShoIFHrQb++xL08pL78BNseVc/vpF0bgfHWUb9t8XwROJ2HSASGgQiKr07W
         TLratfnljxlj81HPAH/Jexh4TZmYiFs0chQ7isBYKNmwyMqULg2odEvBUE/8/9cNMMmW
         IlVadRm3sfrCtmGeRAysVc5CdjuHeAbf7C9+TD5azOZYz4SnXbAxLjQYaLI4NMai5uOG
         EPWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=6NEDxCP1xlNVWbzDZl40x2kZVNRASxcVTF174olVpag=;
        fh=j+e57efuVhiOfSQXlkk1JwI3OAL/O+VojHxNHbjwkHQ=;
        b=ZNGVr4FP999HD89q4IJcIboW4FIBc+DrSIHKu0YKe8Au8ZTFHiuReR1a7OJWWad8wY
         D/VE3A7xliYxgOb4L/xliZYJY1/uNZr1y30+rVbtFlcV6DtApw5qbGERQW6d/qlEAzOn
         mVfXrcHYcH9TM7/1lr4oJW++CEt6Hx0pp/f7RWzhJ9Fy7lRWkYr24GHcgMajZMnFP47g
         APs/hVgL1aJJ9IrjkhWxsGn/qwbOUxVmTrgy2ELxR3BBIgaxa4Ozb7zO8GP02powuW6D
         sNEX/xVR/N35LaFPPV+yDLUp1vpQtHAeDyEgHrfS3tFqCyOaYINpx2BA5oce4b7AJxh7
         NNXw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793975649; x=1794580449;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6NEDxCP1xlNVWbzDZl40x2kZVNRASxcVTF174olVpag=;
        b=SdcAVYwMdWmaY6IQLCmiz5WTYVK+Am3A0ACJ4ctfPqUWih+cybGO27j0GGPtvELW5Z
         ui0Nf01xalShq7tAxdR2FGFL4LzcP5VvZvzutCgB5UaQPHn4ByURnrBTiv9rAT26MIpd
         nwi/JXL4lpauO2Xk5kE8/++n5FqoOP3BbB0ZdQVEzxjO0XX/1TIlaPS/3aTVKsMRVXsn
         gjuBfak9O5ttQb8iS0jOGrdf0FZS7hEZZCJz27tjRj08LNs5OzVR4DfJuecjAcL6jjuZ
         ILddZTZKfueRBGPz3e/Fpz2euPAVleq//+QxB3EZf7HLFkWHJUhmrz2TdOIKcJE+sukJ
         HnSg==
X-Forwarded-Encrypted: i=1; AL+hErHUaHFMJRv3silNxtkt2gPLfktjYgjIki3WeXvuz04oDMujWQMtfSkI/6vZFF6ghUrNVjUS+ec=@lists.linux.dev
X-Gm-Message-State: APuU4Z8t/XQLpLG4h3zZxu+1VVdJH8enPyYZ5eDMASzYQwyQd6RMoyFH
	/sFhvuXJtr/j9/LizSeX/HMAs8ZCPyNd9rWQ30cPb8rE08oaaHYdYSg5r9B0prlx3DLyeiBhrLl
	v/9AvHf8qTjeb8LodoZZOftYC71DuxEWwGwVjn3ucleKSj4LaXAQoayWL2+eGkUFIChnVrEk2ZY
	H5m7M+YGXTXCXjRbZR28RZWxQX9f4r
X-Gm-Gg: AYBFou2b0th1pTm6GeJ8IOqlKI2q1/jPOKut0XWzIOdLtIu8glmkZ6Kr/efo/pj1BNQ
	DwU/kalGUF8ZlKDLe6/klNbgN2B0qlGmbY5aZ8UXBmik7vWgUAkCZO2J7gZNfG5GCGzWNrB8tIX
	HJ7T236dW/BmpOpM1qyG6mDSkL29630GsAN/7fxUGmm2W1U6Rr8PkYkm+rx/37jEDDtLFyHRvxD
	Yny8MCHrr5Zpq9kmTxtoe0HVtyuAVY22Eww5jKBS5BGRT/iFkiwVKSlzLRzl4mQLvoB9cRN4PSo
	CMt4JqQGVYesCCO1/VGyinAEQ0xzsTg6Kw==
X-Received: by 2002:a05:690c:6d84:b0:8b3:4729:a9f6 with SMTP id 00721157ae682-8b34729f672mr7082687b3.78.1793975649570;
        Fri, 06 Nov 2026 06:34:09 -0800 (PST)
X-Received: by 2002:a05:690c:6d84:b0:8b3:4729:a9f6 with SMTP id
 00721157ae682-8b34729f672mr7082497b3.78.1793975649191; Fri, 06 Nov 2026
 06:34:09 -0800 (PST)
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
 <20261105-hyp-pool-and-map-v2-3-44a6ca90190b@cs.columbia.edu> <CA+EHjTx-X_2DaO6Yt-AHsP55SFWjz_EYxEr-TB9WSN-ZT+d3FQ@mail.gmail.com>
In-Reply-To: <CA+EHjTx-X_2DaO6Yt-AHsP55SFWjz_EYxEr-TB9WSN-ZT+d3FQ@mail.gmail.com>
From: Xuheng Li <xuheng@cs.columbia.edu>
Date: Fri, 6 Nov 2026 14:33:57 +0000
X-Gm-Features: AclHuK-Zp8N5uQ35n3k4Ff40s-dY8xGBlNZLkKpIQ2XYz2iYHmj0YH4-CjtoP6I
Message-ID: <CAPOPQMB6eU0MYNewcq8HKsEMchwY-X3aT0Km9uULBappFWZcjQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Don't replace a valid hyp block
 mapping with a table
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
X-Proofpoint-GUID: nD00GQRpNa12jcGj7UQNbAIYvg6yfONo
X-Authority-Analysis: v=2.4 cv=Jt5kP84C c=1 sm=1 tr=0 ts=6aede562 cx=c_pps
 a=NMvoxGxYzVyQPkMeJjVPKg==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=wP-KkE5Gt7gKT99KiR4A:9 a=QEXdDO2ut3YA:10 a=kLokIza1BN8a-hAJ3hfR:22
X-Proofpoint-ORIG-GUID: nD00GQRpNa12jcGj7UQNbAIYvg6yfONo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDA1NyBTYWx0ZWRfX0ep/rLGjZi4d
 ZLr6ZtrEWJEF2n7xI4QLzeZUiQyI5UgvPIOgTXVkUdYNy+B9wOzjPGVGXbajVJGZd/CUY7qDdv5
 bPLXBd0Kr+jPP0JU/4EqU7qMilhScamayFMP/+4Y5O8nGKKTPigm4h+CCGsEc+tW0mvr/WmN4JM
 jMR7HXxjZp7YRpRrKRoNbeQwT4cYy0QRJIAZ/Dlmuk2omB+YZzqZ3qv75Cw4jLHFou6wium+OBr
 fsXOkpyRSdjVD48EvYDYlqYRZ294Ue0+W+ojOWuTCRccPc7/vPMkHHXHTek4nzuh0MYJ6VOo/NW
 ubOdOe3oog11dmMLaB3HTxM094S4qOkr5UTLedjbHlLtDjMUSoW/wtv/GSEVE5MQsU1vmK46i3b
 BVTlgiw0hVDG0BfIz1mW6pCd8xvlyjycSDJMVhIzujJDwi5ZO3z6VzKelBIWquLmVA/P6fwwI8P
 bESY3pUmHLoLSeagrIQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDA1NyBTYWx0ZWRfX0AL051bD9/c9
 r8n1lAQHDtLMdLBIa0d6yi/EeUBiX3szCIZTYaF0N3NUiJpv0cQ/iVjk37yGG6/UKqNDtzNPnT1
 x0M3IGHPZ/dsb+67mJ2iehUmf1EkMvl/oDjH6uGJiUo0kO43+zXz
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11957
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 suspectscore=0 adultscore=0
 lowpriorityscore=10 clxscore=1011 impostorscore=10 phishscore=0 bulkscore=10
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611060057

Hi Fuad,

On Fri, Nov 06, 2026 at 12:03:29PM +0000, Fuad Tabba wrote:
> Could you mention in the message that the WARN_ON() is fatal at EL2,
> so a caller there gets a hyp panic rather than -EEXIST?
> kvm_pgtable_hyp_map() is already documented as rejecting such a
> mapping "with an error and a WARN()", which is a better reason than a
> future caller.

Thanks. I'll reword the message to say that the WARN_ON() is fatal at
EL2, and point to kvm_pgtable_hyp_map()'s documented "error and a
WARN()" instead of a future caller. With patches 1 and 2 dropped, I'll
resend this one on its own once reviews have settled.

Thanks,
Xuheng
