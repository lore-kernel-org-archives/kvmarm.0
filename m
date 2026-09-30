Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E54B4D90B7
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 16:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784396; cv=none; b=fYNbGxmnkmNMXGSZufQjZHxNouBbo2qkCzAmMppPrno7cdDftpDb0b2IX4cBAhB/oGgqWyHNAgi7xBXPpEOWlKp6xUhXhnhwaSElqtjKeDOi5qNnOznC3xIXUkNw9RnIIPNoWj9e2Ff56jMhS3YixAm9e0JVX8Tp4L7uweiv8Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784396; c=relaxed/simple;
	bh=M3mU235Be7SmeB5TrecbBlDrIaYaw+U/+jYODikK3Xs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nUcKhj5sY29kpSiwkR1vGPCyr1VZs1Ndtii/iQg3xEDO+RZlU0Yl17933EC28x83LXOEbF/EP2TP1KA0Q9Af0Xc52YCbZJDXH5/YKC04X9DCZ/zmrQvdotQsj0evdLJ1pTxcNAYiODaj6nCvn4BRyi9/GRUHFcJfuJ0BeoEEIVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GrzS+zys; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=F9bYqaL+; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GrzS+zys";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="F9bYqaL+"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68UE08Fo2970840
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 16:06:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	RJsMX2lmV5ZOu0OhhWQETYgs9bQFhObUxVjX+YGHGYY=; b=GrzS+zys6kCaaQuR
	hoYYKt3vxHvQAsVUc8sd7nR5DNlwNVQ/udeLha/y7PBdkrOan6v5ddR1cVm9uk4/
	QenhZMPEoE+sSrea/Xf7uz3u6zQZ+zmLeh8yOeFhXcYjex23pw7gf/YsduLeNbCN
	36DYaVdtCJXpvAp18lcvQWydfUe+3VFOhZ3fIt4dQjTqmVfwn+pRr4uBO9A9ajib
	Jn5mjjn2PImG2IOXGizFtK9L0rmR07DJB4QON5XZumW/LopQArDtELJI51GS+wKz
	eSCMFF5usimEHanL4mpYFl4PXD20XyLB+Sdv54i+20Pfb7rnXm/U2plXKUzH1a55
	zkI1Iw==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h0rhekrb1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 16:06:29 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-34d84114044so922903eec.1
        for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 09:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790784388; x=1791389188; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=RJsMX2lmV5ZOu0OhhWQETYgs9bQFhObUxVjX+YGHGYY=;
        b=F9bYqaL+EUZE/P+5s2qoc2/tprKr6E1/4Y1INGIKE45SgVijyXMlbaLq/Y6JhSwI3q
         2FwG4fDG9LEDkH/Q73FCHNbXBweB3c/vh0fEkD0vdQuyAAqa01rXvFI/G1GJV5vJQp8g
         HETR4Z6tsph7QlfH8OcOw4JPi7H7Z7QsNXSFiMTOKIp53jaowWp7Mhq6D7U2gqHvz9Gj
         GA34Tn5/Q9DczQBKUwk+jxjVbtBWoVOb6+NvZNIFCfg2VIOPb1xuFi6cgpxypWAhvQTl
         7txFWOd3tqj6+Bow6S9bVy3zB6GAwXsFOKxc/rRRkKBFU3LzVKiuhLOnxyUyLVd48vbv
         MlXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790784388; x=1791389188;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RJsMX2lmV5ZOu0OhhWQETYgs9bQFhObUxVjX+YGHGYY=;
        b=rZfaQfd6hHbH8PxxkNNoSEDyD1eK425IoqmDisiVoKOkLNSic0/GZVDQsPP5aBhIBw
         Y5Pjv6uPu735OO2KwUBMk4lXIAf+cTUz4iTd3yPpX4S1WjL5aqlsvUj0qOX5MYR9ddi4
         kkAgLMejwcyP2xds/TjVvfWGswOYLb10iRg6cdYK8/y2Ui2M6H60aQpQSNumyJRXIcfI
         ELpk1xqWIqveO+WTON148fLF0en1vNHaAl1gJxhqGEfvxHB5z6SYA69JtFxfAn5drl3M
         aMAkhajoUZRg9qzqHJEmwDFv3DxNffFbg8kYBe+Hn9t3ipAJUJPGaM4nN48Ls394/zyv
         trJw==
X-Forwarded-Encrypted: i=1; AKwUvBw64jEZXVbKVbm3tzeeKnIfmHo2qi7KLCclJGwMLdTlZVk/3gcFw3mMJ8ZQFGgPfe//7mc7bCg=@lists.linux.dev
X-Gm-Message-State: AFq9FYI2kQpJ9l0Zez58EufZkM4YuhKeIJ5ehcOyRTYVw8ypdrXB03Tw
	tudN+rabNQDOkK8noy6WdRYZw6yH/82UvvO17V387fVVU4yRMB4t8AKQ6rsFRtZpW6XpJC0fBzB
	1nQTx8DvkH1CnMUNRV3Pdiy04hquZYztJnUkxj4kkc74Oj90QQvZQnD+Rp08=
X-Gm-Gg: AYBFou1jrbr+vqeAct4NLp9TJZ/bO4Y9RUj3NrNkrXbvWXLx4G9Mi9g/OnxSajVA1iT
	2LVpPLWmDA/0LtFKt0I/ghb1NR+R47Bp3O8ObLqetm2c5aWpkh5elzwHNMEZy8fXPeeblG6ogRf
	SMC76rqSYOn/hqcrf5oPV2GoP7oiYni1BfZnYeOFHtNXnhouHFH5ZLKIRzM6B0bxuVaDAlLSU41
	0phgWkR3oXB+T8ciDaImIE7jg8j6MjiQ2m3aC+tZOFifbA19X2yy0QnEiN+URo4pHU5FtApNasw
	E7dwMvshIMIO2IJU+76GKgG78p5zhDMRFNjrXvfrpYfGL/z0Ok0ywqG6EndlGjlAI69YM8fxMco
	UdvUApBgJl0cT92i9c2ikGwWhCq4TUhiAvXtxahoEFSbDhGyGaI1ZKA==
X-Received: by 2002:a05:7300:f791:b0:34c:5283:4f07 with SMTP id 5a478bee46e88-34cdd792968mr2177194eec.38.1790784388256;
        Wed, 30 Sep 2026 09:06:28 -0700 (PDT)
X-Received: by 2002:a05:7300:f791:b0:34c:5283:4f07 with SMTP id 5a478bee46e88-34cdd792968mr2177166eec.38.1790784387688;
        Wed, 30 Sep 2026 09:06:27 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34db0c8e76esm167595eec.4.2026.09.30.09.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 09:06:27 -0700 (PDT)
Date: Wed, 30 Sep 2026 09:06:22 -0700
From: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
        will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
        aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
        joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
        linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
        sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
        WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
        sudeep.holla@arm.com
Subject: Re: [PATCH v20 7/9] arm64: Block hibernate and kexec while RMM is
 active
Message-ID: <20260930090622.00006590@oss.qualcomm.com>
In-Reply-To: <20260929221623.1342076-8-suzuki.poulose@arm.com>
References: <20260929221623.1342076-1-suzuki.poulose@arm.com>
	<20260929221623.1342076-8-suzuki.poulose@arm.com>
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
X-Proofpoint-GUID: vZDPH2Nhb9cTIdagShATtafBcj_02NuA
X-Proofpoint-ORIG-GUID: vZDPH2Nhb9cTIdagShATtafBcj_02NuA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA2NCBTYWx0ZWRfXzHAy13/QF1xd
 05SqmINbCoBHbq3oKfi0+mb7Qe0nzEvVrs7yvwvgfBmJUDP8V/nbrwShniJFQz1uUY3eVEtBGRV
 s6FvpZDIN+Hq7wJZ7r1TdU65gPs6KLPmCeS3Zpjbol4kgWN8HBq806FjPemGCSvBWAaZyfMmrzS
 5SehVaIcMLMHY4uPQYc524gOPOhkQxy4ACEh8Smql1Oozdh+lKif95HwVS16v6hcCyliikfoPdI
 oWLgaK+EDk45WYDwwbfLnQbIi8R2khp8VOXkERP3exeo/HvV/8TObkMPqsjhGgz82eMEIMc7tcg
 PmcbC5SSlszplDgbKhUiffQKh6Acj54DWXILzXlctbGOTaw5vXq/owpWNx8oI7ygw1zsl1XUhyU
 wsYlyLE/ewMbdNaYJnN+HflNE6XeXP9wK/LEcJ/EDcPxFD2lcS9zTNN2Ov89aimSvD2V2siKu9Q
 4TDOsMn1UW//pqFJbAQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA2NCBTYWx0ZWRfXxHavrxaA48lu
 Fs15ah3JVM0XaW7FmjPFSoDCovb11IbAHqiH1AGlnGWgWm/ynLYqFe1dDXNA5OKV7pVflHLzU9N
 PXrwWiVczPsmQQd4HMFcn6HpDqn1QUA=
X-Authority-Analysis: v=2.4 cv=Tu1zFzXh c=1 sm=1 tr=0 ts=6abd3385 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=7CQSdrXTAAAA:8 a=EUspDBNiAAAA:8 a=LZvgd7wXd7bcPLl1K1UA:9 a=CjuIK1q_8ugA:10
 a=PxkB5W3o20Ba91AHUih5:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300064

On Tue, 29 Sep 2026 23:16:21 +0100
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:

> RMM can be deactivated only after all delegated granules have been
> reclaimed. If a new kernel is entered while any granules remain in the
> Realm PAS, accesses to that memory can raise a Granule Protection Fault
> and be fatal to the new kernel.
> 
> Crash kexec/kdump needs separate handling. It can be supported only once
> the crash kernel can tolerate delegated memory inherited from the primary
> kernel. i.e., be able to read the pages safely and fixup the GPF. Until
> then disable the kexec completely.
> 
> Hibernate has a similar problem. The image cannot be safely saved for
> delegated pages, as the RMM doesn't support exporting the pages.
> 
> Disable both kexec and hiberation while the RMM is active.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Not my area of expertise but follows similar patterns to blocking these
for other reasons.

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
