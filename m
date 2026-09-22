Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040D45326B1
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 22:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790117689; cv=none; b=c2v3bPrdmPnsOXNgnnQlC7sTYA4krt3EclZKMJnzuu3qjTqVvKxgQX12s8RRksjKzuZahoma2EXyRA0p0thzzGuc2Pq90omT2pn4qPHqShy/TGU9vpzGQu+lKg5McMZnFfqrKKK5szfxFEhjZq5Hw+tiZMyaYLNywLxOFu2kZMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790117689; c=relaxed/simple;
	bh=ySnK+hmdvoPJVkgFkjfrLJlNaWN5LOaQraKbC5hMV2M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E/wT60x5JYUbF2piab6YzfMZG3dllF1KMuB3fkep3bCSgnNhVGBDFvsu8hVXiDAVDp5ZROJF6mC1VoWV9Y1wzUKQuIHgolaUG9DdSfEc1GzOSZ75hgMO6GP8mNiZsuhYBC8vOZOGfR9fb+mSctMJ8QsoYyurpiwL+2ps39NYh7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TgC+Jg22; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=P+QzJyKZ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TgC+Jg22";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="P+QzJyKZ"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MJBhIQ3897576
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 22:54:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LYxvfTdm3oz7TymPids4imwzrOSBJe+ux30GQWYD/WQ=; b=TgC+Jg227JT54tl4
	P5oAiVK2B3oGJAAJMrXG0Kz8oLZBB5wfKqJ/JTsnu6gDea3KvxyAXIqy06rrQHxJ
	BPTXp5Bw1Cy9Fx8d/V8xAxo+P/+OiHNzL9zUc6Wsok79fsbGQhIzId94CBYHb4bp
	skBUEfTUJYU+vlOqfF0o1arAozn4tgbQaZTjqQGXJKuL6nusRUJBJ3LRUKtFj13l
	aXK52LiNDgboYOpBgBX3YDbe7Ba/CY6ZfpjL8mVgbTDTaYgR0eW/eX3v1VCLU+/R
	aJ4fgVdyZjItZV3h+Jut4PysymBjF7GY/dpYwi6CNF1CHWgEUmcVoZBrwjvk4SCb
	hqqqFA==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4guyma0xn3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 22:54:44 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-30f1b904861so385240eec.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 15:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790117684; x=1790722484; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=LYxvfTdm3oz7TymPids4imwzrOSBJe+ux30GQWYD/WQ=;
        b=P+QzJyKZ7i3nq5JolGkI8EADR3/EndzfOiXwIExcPygyWYEvxesu2+oSmlEca0eUol
         sqUoJ186QLtMbCJ7NU6IoenFh3HyBWz8N8u4GOr42EqgPUQQXHjrS1zHuPYh6esqiN4s
         cXG7ub9fNkgrv5npLwOYwlcjAWku5LGVXU0FEraTkYwPpsRJXclPLZO3X8ndvvHvSoLu
         USM84xcW+qxDY4Tat9R4PHP1Ham59aSUKpkQKwklloKRmUp0ugnTnOEWan6i486a4R2A
         AL0sjXddKFxqqY+ZuoJjqF9qWXhwt5p4wF5spibeUf5gt/KeKjfhGhlXYB/pr+rtTqdA
         nBYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790117684; x=1790722484;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LYxvfTdm3oz7TymPids4imwzrOSBJe+ux30GQWYD/WQ=;
        b=yFYoZu3cMIDlMcnp5diGZe/nxbKGrP8rFD/DhM9h6FzJPGU6e8GGxMOGbrbBw91qml
         6Bnvt6nrVrl3mm61LUKma5colNSPoDmJctxmU+VsgICvUaCLUV1QbzLiQ+u4A1/kqoHb
         gtJfCGXpWkUyc9caT4jIrygIkQpBXmfsuDfUjnkSORYr7r/HnFtmImsdODICQgWekixZ
         IaEkzFUANKfR1s3CNxbCZYS7VMpR0Nxf4L5xW/wgsz7wIRVt+4tl26+D7OsKy53Ydqc1
         FAW1PbMknfthhejj4o/QyNKIS7ISR0Q8lULNinLNGLXlBi2ZclP/CeNhonIt0ybmpG0c
         e6Fg==
X-Forwarded-Encrypted: i=1; AKwUvBwu+U/PXkIS6OCvN0uq3Qygx31v9m4BitSg0Lo5zJ2pvMRWuofvoFp+XdBOHt+jdwLh5pa31d8=@lists.linux.dev
X-Gm-Message-State: AFuF++lzf26gH9Ju58n9nZZfAzStmeL6fL3Q7W/iJWSK0CnAnNVLVWvj
	/ZpCTLyzj4czU8sPD4fHZW3Rw+D02KlRArYpB3N+/olQWZkBfRUgIQD+1xKPHNVYu4diMqEccXy
	fijPYDJ8jzjwYUPTJBLCm00DfAglYX2fpSCY37oWlVBT4eveatHpPtrCVl+E=
X-Gm-Gg: AYBFou3LWW9wBzyCzJuX8bVVMNEEcbeCh3ZXRL3d1Sf/NPNRlBIN0oP9BzoMA4Vf6Nx
	VWvtPfDx6j8Goa0EFcoZHzbQ+dxsk0OhlCbjAnVG6QFGI8c9IENSsE92cPUDRBKRcYWu6TDNTOa
	JKQDiWar6AGYReSX6TLlUam+rQQTMiFq3Fd+L5eN05lzDukOUIIPOV51MIlfz2skC6b8njdWzBP
	zbnoEqeNJlIk0wgSgxyf9DvJq7iuNhFFZedv7Kuul0Rxtai7E3AZd/G3lqeWdnf3at4Ohb0XzVS
	PslIBSefkjIH3gOI1ZMFzevrFP4xQYeA5vIpt7fK/PEhDJG4qVSmOuPxJ8JcWimG64llRLCkNkb
	G199H2sX84PocPKLr6LbnjcHDaMGAdMMsKqOYC76lVsyb3kdCd5sr5g==
X-Received: by 2002:a05:693c:638c:10b0:33e:6a54:b3ef with SMTP id 5a478bee46e88-33e8c05f69amr760383eec.18.1790117684085;
        Tue, 22 Sep 2026 15:54:44 -0700 (PDT)
X-Received: by 2002:a05:693c:638c:10b0:33e:6a54:b3ef with SMTP id 5a478bee46e88-33e8c05f69amr760352eec.18.1790117683534;
        Tue, 22 Sep 2026 15:54:43 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e96e48e3esm1320134eec.26.2026.09.22.15.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 15:54:43 -0700 (PDT)
Date: Tue, 22 Sep 2026 15:54:38 -0700
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
Subject: Re: [PATCH v19 17/20] KVM: arm64: CCA: WARN on injected undef
 exceptions
Message-ID: <20260922155438.00000f3d@oss.qualcomm.com>
In-Reply-To: <20260920212845.707-18-suzuki.poulose@arm.com>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
	<20260920212845.707-18-suzuki.poulose@arm.com>
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
X-Proofpoint-ORIG-GUID: JRHUidvEyA3paOSAapqUUQe9kGN5kjdH
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDMwNCBTYWx0ZWRfX9jKT0RH/cxjG
 bYoUv7ac5OXL1BAe5wxe4ZEyNGVeWBHlYfZqUglJk0IsgLlMX9pL9ROajfdnCeLwheZGLUI/Udy
 hc3w9Kn3meN6yz4mqG+48rdr66REH/E=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDMwNCBTYWx0ZWRfX9ET0yXcFo19v
 M+NGKHW7onJkMv+vr4MDmvr9dKtB+xyVYB1WYfLmKE8OXtLwD4TCtYT1K6IIMqfBgFwd45TC6PB
 b7KGUH3AG3ja7+UNZsvFCI5bs1ESpuBFr33l72NBO9oOb6vMmwigHLl3ehI7XRL5Xx8eM8NUMom
 Hj2B/fQtO1NSTMAkeSRttvhSXZdPRq9iOkxEB3j0am2BYsiH/cMsRGn7HfNKL8EyZGBonK9iXHa
 UlXKJwOhffwt5hIOFSqvQiu6Tacnf6h3A4d9ko1xtyqxgEVWGY+um6MJWsLJeC8hb5NpYZS6+mh
 /uAesYNJujpJZXRh/+ezJtfF/AwUAmTB+k8LT/WYPJWaQjiqnYBptSeSKwpkYgwgtXakbCYjVyG
 dXnqgsusIMXXeYaz8xn8fsWRpejV7ckEhNBELi4uaWvRqIejQGaC41y4ECVW+dzZpn4i5qJR5pn
 TqzNJhbPY194XW9aXuQ==
X-Authority-Analysis: v=2.4 cv=N828hG9B c=1 sm=1 tr=0 ts=6ab30734 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=7CQSdrXTAAAA:8 a=EUspDBNiAAAA:8 a=DI-nzRUvp28q1R9r8mgA:9 a=CjuIK1q_8ugA:10
 a=bBxd6f-gb0O0v-kibOvt:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: JRHUidvEyA3paOSAapqUUQe9kGN5kjdH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 malwarescore=0 adultscore=0 spamscore=0
 impostorscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220304

On Sun, 20 Sep 2026 22:28:42 +0100
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:

> From: Steven Price <steven.price@arm.com>
> 
> The RMM doesn't allow injection of a undefined exception into a realm
> guest. Add a WARN to catch if this ever happens.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
