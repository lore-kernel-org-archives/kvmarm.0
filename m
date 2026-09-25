Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DE639A7F6
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 15:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790350249; cv=none; b=DhrgoemRVDFfhY9rE0TWXl7A8tfr7fQEVTJ5F4qHSyrW6nAiiDZ/erNrobi7ftGbEGS5eDvSRYM5xus2AvGSen6GlL+OMmLrgZpPHHHgeSbT20Kb2K85dJNuTw9LV87KtS85ZdWcuUs/wPG86aTxodzqKVeQQuGjGaHrgyuE64Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790350249; c=relaxed/simple;
	bh=xv4odhemuBPAS8kcpf9YEYjSYrExVy3jQi5ATSg6zYY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=St+JSpPDHUa6Ex+tE3H40z2F68MuL1PEL+F8ECgcbt5lxfN8/VodFDfgjSkYvhRUET3AfJqc9zxOZhzNG48RGLXVi7JpGA3EDYGCTLZoV9oZw519qJ3EfMCPXS/tHexkLhwX8DEStOue7iQQ+njdVZt+H/37GoP1yxaTUsEV7os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cYH6Ycmx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Q60g9f0M; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cYH6Ycmx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Q60g9f0M"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68PBLfQ3900383
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 15:30:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	eaED8Dj0FArN5pZ3q8CQ/4V/GaAP65mI/2pqKsEpiWc=; b=cYH6YcmxSpRbVDv4
	ASqOTKC8Ww3v7g4z40EX0CE80WVfVuMpO91dMVOjuCuMlVx9uakw8rjWxzSslUDi
	BxN/hQ3cPv4pIgMMtjhGcO6i2V7fvzPCApLgzZ7CMvCmcjQdclp4ppbCI1HBqaZs
	FIJ8kJaIBmcqRNS/2XqCkmNCgNbY3uTJzlwIgP+GIzIwjeW+iA3w0cZiuYp8dRP5
	n/ZbiKIwYy4uIhZihgp/w33uHKm1IbjrBHKIA6o0TWOiWmKhd5xUqak/wbExlYaT
	LlkBLdBX7UFnVJeJ0kFaerkJcMU592JHFDqolqv1SlyNUkql+l0Rp+usn5MJ4aWn
	eUf5Lg==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gwr100t8r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 15:30:47 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-9308eafb465so266857985a.2
        for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 08:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790350246; x=1790955046; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=eaED8Dj0FArN5pZ3q8CQ/4V/GaAP65mI/2pqKsEpiWc=;
        b=Q60g9f0Mtbws/8QbiXH1LbcuTr6iAC5P2WC3FaQVgb2vdvZtyxkFQqfAEN3/DfLrJ9
         wUcotTHuMAcHaciNcS0CTOoS3yaQ/xS1jlyu2SFpMGNSZZY1G1/5bmEJmL2L9cc9aZMU
         k5y26IsP/riELbHk/7C6jTrVqxZjMaiAq55m1LA2AfUCfYiER+ugYPYaa9ipuP6GFhkE
         qyZ22p9cuFRP/QKr1A3hnPd+tK2f6+/6Wxl91sZucargvzwrAOOyxQgE/TSK4t+P4XPG
         t6UU5WGZ/yDUYfC9aO44mSzMt5opht84S7Ivp5EzkJJXFsOzHTJEkR7R4mya4yY2jqdA
         dvqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790350246; x=1790955046;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eaED8Dj0FArN5pZ3q8CQ/4V/GaAP65mI/2pqKsEpiWc=;
        b=VjDcL2loISTelKt/8Uvc6gC7akH0cvRI6ebWsQ5APxSMUVmjpX1sXl8183qDjgAUvW
         d1GYftZyX3MaiAPQq9mGrcV4Tz4mARHaIAdgJN3JDjbWdJZk+gdOX4n93fdKgA9CNR4+
         X6Fb+fJTk0XIKUIpeIceHuBn5AJ00K2MGTy8JBs1WHqyXdCxEo94Rw9Dv02uhWa36xng
         Copjnhw+9F2bpqs1KDQUNw9Blw71VCxThaYj2DUrgD6yeqziPFMs3OgNwQpc/qPXbB6D
         UXbhYcHcmpzh/dtryDHob7c+44OFqS4wG682+PeEf7dPRTou/+kHt9RH+fc5DkYKAAtY
         vUkw==
X-Forwarded-Encrypted: i=1; AKwUvBwg79LOk7uIv4cCgWA6/Q+bF7TgJyJMByr41ugxIq/FEnCp/yXKdwkBVQ/pCJLrXk4EkFbckp4=@lists.linux.dev
X-Gm-Message-State: AFuF++nT8AKDHq4d3Xw6cEO/oQdND6TWqvgVwakJhYY61pA8IqAZFxwl
	lEL4PNYJR6lf+XlGjeJH3xXTPqU/DJOIFqNHc7JqiQA+0o44jAv1S1tX/78OC+vOD7knaOMyBAs
	e+aGrWdjNdL13NXrSyWnizenkNAwHrItF4CspBIdaG7QVtjThnxV0DJFst00=
X-Gm-Gg: AYBFou3XANGWQOVWlv4RQLUJwnz+NknmPOdUlw6dmsDJ3mIMdoFmdYTE3gswH21OW0+
	BqrbfrauoROL638Jz7lZHscYlBk/qTaAyyQ5P9SDCpvxOvbLAr1hW2mQoh6i267kNwy6C26R7Mj
	T6H3WSZAd4X7gyLNaeoNFLDhMm51JiXvh+gbKfEMcS3psbjfrwJ+VPA2U7zt/fguAcsvnUYtPk1
	aPbSjKZ0Fc1HSEfR5ckTVKLXmJPZQTwKgnkXl+buH8zy/W3FjftGWhrk78nvf5tkbkl+ed+6cbW
	sHZHLGt/miZOHbGMJ+GqRpNDhUZfqE/qq4Nae2TlOKZhuy0/IvvFcfQ9TXsWWMAq3z1AbfPgLzh
	C35LfLCxXjic0bv4UyLNPbqi0cxzPOtyMWngkA8yeMuEW4yCAgbAUMA==
X-Received: by 2002:a05:620a:2915:b0:939:d5f4:ab5d with SMTP id af79cd13be357-93c47498881mr439176985a.33.1790350246430;
        Fri, 25 Sep 2026 08:30:46 -0700 (PDT)
X-Received: by 2002:a05:620a:2915:b0:939:d5f4:ab5d with SMTP id af79cd13be357-93c47498881mr439169785a.33.1790350245846;
        Fri, 25 Sep 2026 08:30:45 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c44972febsm205040785a.39.2026.09.25.08.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 08:30:45 -0700 (PDT)
Date: Fri, 25 Sep 2026 08:30:38 -0700
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
Subject: Re: [PATCH v19 6/7] firmware: arm_rmm: Ensure the RMM has GPT
 entries for memory
Message-ID: <20260925083038.000022df@oss.qualcomm.com>
In-Reply-To: <14c6a10d-2891-42ce-8dd8-9745be2f7347@arm.com>
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
	<20260924135201.850038-7-suzuki.poulose@arm.com>
	<20260924143821.00003491@oss.qualcomm.com>
	<14c6a10d-2891-42ce-8dd8-9745be2f7347@arm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA2MSBTYWx0ZWRfX8lhCxKDdci4H
 nIJSLo1PEjfBWzjbd8yGsewuFi6rHdreyHCcfK1+kVJsCB1DIzxVsLfLfXnTotGeAR8yxzFh8p5
 aqwX5KaHDDrAvctP3A3aoNknotbYxGWY6GJkzxMu8xyKee1N9ooDyivjw9aAw8uBGWafI4Q8b9v
 cYXdWFq4wvszcXMlXRineUc/hiSWx6WunPwfgekYMKYZP/P7leO2bxUpJeyX7x7IgnUiqHb3yeF
 TYQvd73/EeMYhvHfeCmgj+NCj84nb//SXuzoLa/5zGXpoF+lKEEAuvZRaRGEzYaNhmCyLvRp+K0
 f/96vAePggZvDALSDkDeoxKdSN6qAOvN1ncB4ybev7BwkygXunutUAbohvPUP2rlF9iYaY2Ewrp
 P6bIw58xUKT1fSGg9B2I8YMAt3MDzSgFTonZ2Wm3d4DLGNljD60O6OrxjJY43K18Hho+2hGaCvv
 098Gkq4rqpHHr08b4hw==
X-Authority-Analysis: v=2.4 cv=ZfKIpcVA c=1 sm=1 tr=0 ts=6ab693a7 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=CGxCOrlZwYKUQMMqFN0A:9 a=CjuIK1q_8ugA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: Q0FodZiYL4PQ01J40_GwFxHWUN6Zuv_T
X-Proofpoint-GUID: Q0FodZiYL4PQ01J40_GwFxHWUN6Zuv_T
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA2MSBTYWx0ZWRfX+NGO+7hanPiH
 m6XlKUGpo7yf7GylvFxujZ+CbcWspvmKmw5uLUPYi8zUR0+FCD0OlbA3EpPGDfO13NswTw42Ask
 lU4/y0/8eE3XsdP0nXUSG35Dv/ZuDmA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609250061

> 
> >> +
> >> +static int rmi_init_metadata(void)
> >> +{
> >> +	phys_addr_t start, end;
> >> +	struct memblock_region *r;
> >> +
> >> +	for_each_mem_region(r) {
> >> +		int ret;
> >> +
> >> +		/* Firmware-reserved NOMAP regions are not usable system RAM */
> >> +		if (memblock_is_nomap(r))
> >> +			continue;
> >> +
> >> +		start = PAGE_ALIGN(r->base);
> >> +		end = PAGE_ALIGN_DOWN(r->base + r->size);  
> > 
> > Add a comment on why rounding down.  Doe we expect that to ever be relevant?  
> 
> Do we really need a comment here ? We always deal with PAGE_SIZE and if
> in the odd case this region boundary is not PAGE aligned we stick to the
> page that we can use from the region. I can stick in a comment if you
> really think so.
> 

Ok.  I was mostly thinking that it was an odd thing to happen.



