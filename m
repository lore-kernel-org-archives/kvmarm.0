Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D454A7C90
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 16:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790269135; cv=none; b=I1jmhFSi8a1XUUIlCkjvjGxX3h9mpwbVJx2lfI1/96CnpKXNbcooLya9+59pjXYt864HZ3/gFo84sOev48sglNbfZsU9E4W48/nkzm4RASQdK67MrToQ9k7au/Nw6jnARpWl9s9qdbWYqK4EghCJ3DAYC/w8hWuiBn9CmaukKoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790269135; c=relaxed/simple;
	bh=a8A9yqjmhJ/+cI4yw1HQmLXjHtbCYV7LwVPgha5XwhE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xr8Jc2Mjm4AB1yCWmprYDjqHaIkFL4HWNGCsfEhDhpHgHvxF5eXGIbQCi/YLW5z3nXkjIh8LQ8B914VKmSuMS5A3r1/i4WlsopOKAXAG+ib/XUQxYaVFA2JXvTZBbTN1Uibv3k5b4gxdyBnUcTmXmpLp0MkoLfx24n9MBG/sxgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Xu0+sAhP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZkUfx7PC; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Xu0+sAhP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZkUfx7PC"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68OFegBV1907528
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 16:58:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rFAGiOFg8Ohk1lbqGxk4BCZDcIv/T4pj8Ax5ybWtFqY=; b=Xu0+sAhP7595qGZV
	puFGsMwbl6q6Rc7svCwZK+AFgMMAFmZn87UZ8N7stAWgs0b0fX/qeHfXEwPqf/JI
	jtokQwdafNIMplnB+yMcLHyw+cW2OteWLk0U7jB5dum0+Gi/XCATXkWIncHTNygg
	sddbbfhSpaQFHFNsp0+KMdS+G74Gb/U83Q3pe+ucyP+BmwIwCjbJI5tR4fVCVMzB
	zgp1sV3lLSGYNFQktGsggcc3+d5FaiXwXpabwwiX70UTB3IMx4MV9zwSKRVDeG6R
	nJ4WDyHPLzInzX0l+Ks9kur02sJ2OKBXTJZnHpgLhC4ExgQQkv/n6naBb9WImHBw
	uIJqUw==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gw1t7sp9d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 16:58:52 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e8e864ef0so104245a91.0
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 09:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790269132; x=1790873932; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=rFAGiOFg8Ohk1lbqGxk4BCZDcIv/T4pj8Ax5ybWtFqY=;
        b=ZkUfx7PCszglNzmHxhXBho4yyRhL8wImdsxfAnZsb4JyHvBXTTgkDcPmOInu7/tjj6
         QgzDK/nV0TS2mQ2Tbh/rn1rEcV1MWfYvfA1AlkCJQWmIg75b5C11+6O+ckXA0Qktgh2b
         QcWA+GpLdjX+U3Uq+A1TNbz2LjgDuMg4WRX0VlYfB12TDw+QvSJIxaljEBQDsSNBQbw+
         9b+/N07NDeqidnDXkJcKnc79U83H5Q4O+pjA216tkLMDQr9UsCrdFIsbW02mE0JzYHT1
         jRVUJlkVx1nHS6hAu6WaagOX/CgHK/ZjJRf7nPs3YX+7BmGC73KFxs2bSYC44Q3ITg31
         4Ntg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790269132; x=1790873932;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rFAGiOFg8Ohk1lbqGxk4BCZDcIv/T4pj8Ax5ybWtFqY=;
        b=qTUb+QRPales5t6QA6LoqlNQ2k7OGD6iiss1mLSqqbv0vRRuNV5MOR9W4F47Uf0VLq
         FRmuY28vxARuq4oauKQZ2CIXGOKchYKmuppphgVpwR379qRAGlZE7Qg+fmTpsO11/mdW
         TeD2rOaDub+U/8y9UgENsPkKKrSaYi29IOAoxZH04No2JE4e5gAMJYG9eogemSP7dvmu
         U6HAMZIQ2QNdrSLKTeAFevCZztMgmGRD/NY8+AhFIupHW3CAUucHo4J9nxZ2kDg2L9BS
         IExDWKXYkeXMRMCUWJ9ar2CTkYkM7igcpWNLxEqOQZig2H5BMcvXc6QfaEBlwFdqVmD/
         RBhg==
X-Forwarded-Encrypted: i=1; AKwUvBwL6kjFKr+YHoaLqrqonZ946S2S0DGApRG93/zs9T7ivyOiayU+XexRWGsNSBQNOvOT7mSSTYg=@lists.linux.dev
X-Gm-Message-State: AFuF++lu0KA6NB8DoO0NsRE/1e7dXY0aqRj97xN+e+hP0LtWgTvTy2hI
	D59b5v5DEwApO5rCtAuepCJzcyjsiJbCHAu/tIGrqSwdqn/t3zf12H67TaqWYr3fp2EzpKFEFDB
	vlxhXrO4DRbGBZojU2MVFa5NqTb7ILjijrBlGGBedQI7hZ9alLKnzNIEayzc=
X-Gm-Gg: AYBFou16att96G8hDtNW2gIoT6q+DjFMCbLd1mhUjJLgvFOY+oFIBd1zQGGKTzhq9DG
	n/6jdPEtXXvgGj1aRI3+MctZiD6iODmG3LCvQskf/xfmu7t5AIgz9KV6XznM7UR6Q31LDcDnndz
	gTtxlddAnCWW0LIdKfYO4csDVe18wPSftxvvfNodHzT6SHZcT2JWdbgniAt7TKrndXZfZHqIqG6
	joqmXCTFWQpaLRdlB0S2oBfBg3jA639DCJdYBUzX1BGkh+TwZ5ItEXJgCdiFOzYs0HuDYLCPI7q
	lfsIq/W7v+istugAcT1tLYryxXERLdMpuYwzaHwhIuPtd9mGXmvtZQGe1LqzIXJzz43hNW5LQP4
	Rt2kN0pHnAtQn/BUD+ff/tb6ginDhkKhG+L/CeVVbyDIqtlQQn1kvWnI=
X-Received: by 2002:a17:90b:3c4f:b0:39e:6c69:7775 with SMTP id 98e67ed59e1d1-3a09898525fmr2917449a91.30.1790269131560;
        Thu, 24 Sep 2026 09:58:51 -0700 (PDT)
X-Received: by 2002:a17:90b:3c4f:b0:39e:6c69:7775 with SMTP id 98e67ed59e1d1-3a09898525fmr2917416a91.30.1790269131105;
        Thu, 24 Sep 2026 09:58:51 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0a8d290d0sm2047321a91.13.2026.09.24.09.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 09:58:50 -0700 (PDT)
Date: Thu, 24 Sep 2026 09:58:46 -0700
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
Subject: Re: [PATCH v19 2/7] firmware: arm_rmm: Check for RMI support at
 init
Message-ID: <20260924095846.000051f3@oss.qualcomm.com>
In-Reply-To: <20260924135201.850038-3-suzuki.poulose@arm.com>
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
	<20260924135201.850038-3-suzuki.poulose@arm.com>
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
X-Proofpoint-GUID: XPe79zL2KPQOLiLWSP50qWyNPaNI3AIO
X-Authority-Analysis: v=2.4 cv=U/MHnuru c=1 sm=1 tr=0 ts=6ab556cc cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=7CQSdrXTAAAA:8 a=EUspDBNiAAAA:8 a=iEv2s1z673h7nQAfKJgA:9 a=CjuIK1q_8ugA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA2OSBTYWx0ZWRfXzItvxKzO+e32
 KLNaZtxPWNU9hZH1RNAgYBtoBtmcCx7iZgJ769qmLVOCiLZDDarbHs2Xc5h0r3VAVW+n1dkIme7
 teaPyYe8HjjOPKryXzQGhYMHsvQdNsIlj5V5ZxyVCTke3XM9ZiUlG9AfLWxUJANGgwSWD7tqdU1
 UP63Ksovu4WgRc7a01hpbW79yED5bXfr38KUnxgb1nuqXwg6iMDme3pGLBNgULPf6bqQQe224RT
 v4kmZgiPSYHoDxx/eo7biHsJtSB/EwjCp6pIlg2fXLh0tSLHygJvHYUTKcKmT9l6j+ItIFkotGO
 kPzj9PR+QG07gpKVSs5nl/9FGrSzNIQwhSI6CI0S7TpCg2CG3WuuKjmpq0ZS7CRDEl4i4BvCjyY
 S9idF/CgoyiMPsSfvAPTElF73qDwO17ZcEPl2qknrMQn5yJPIlbOT4cvLA9vZ+tYZGmR93H4yO9
 jtCzJme56ot0zRP1yOw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA2OSBTYWx0ZWRfX5hnQXizgN6cJ
 7OfWvkxNgQYqxmtbdtakp8f2tVhHiBQyPlp30PsVvCR+Cm3uFmTakgnpksKDjnH7whTWxOsAS97
 Kr5C5hb9RsX34srB+YpnqYkS0M3Cs0A=
X-Proofpoint-ORIG-GUID: XPe79zL2KPQOLiLWSP50qWyNPaNI3AIO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240069

On Thu, 24 Sep 2026 14:51:56 +0100
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:

> From: Steven Price <steven.price@arm.com>
> 
> Query the RMI version number and check if it is a compatible version.
> The first two feature registers are read and exposed for future code to
> use.
> 
> We only support this for Little Endian kernels, the Big Endian kernel
> support is anyway marked BROKEN and is being removed.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
