Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6872CCC6
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 15:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790694027; cv=none; b=PcK7x/eGWLOLLAqfbyGoiA8AhtB00FM5iBgcFbxZeePpxLlKsT1O7Cou9sD8LYEshy1SpEpx4zlBKKyKYl2sG3sWl6iRE60FNejkdmWVwrmRSZl95FzMUrfBEnJAR79XUwX79kvABqx5sdYVo+jDsDvo4t9vfB1zfL22n/NYJS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790694027; c=relaxed/simple;
	bh=GsakeEenWM3qJ5GvobTU1wzl+3gUC4dDLJBugVlnp8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VPg/kSlUoS4OMvWkAQUZ7tK0ALhLH+h0rRf3fIEVRcQ55iW4akL2F+d/lkK/inKPKYeZL/lV6ULXo2ZPOHa/DeaNhmY+AYOVFDUEIAz0W0WJ/5pYA//wkdSt+KiqZ7sxMdW38w2UaKliKRt9cptBlDvgvB1ABX+HtN1xtB9Ct4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=I3uoVswz; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=koNk45XH; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="I3uoVswz";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="koNk45XH"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TCqdCF1576994
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 15:00:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oC6ycxct5evGf7msqSYvksrjwR+3Ojl2H7PIOG3pGA4=; b=I3uoVswzPOAVm45U
	TySoSv+ewy4ebXsFI5kGIvjFmCG2aGKTapyARHykhPziLI1dvgeJCBMgbQJM637F
	YgCVPCaEM6MRsSMgoOzaAlkb4kcLRvAIDqpP8VnjmjZP5RYb//VVIaXwT5T2jKw0
	It0z1aq+EjF4HubqI0tWmdcikjGL6pjh4EEpZO3YEFLxIc6NSdwUVNBwaBiVM8kt
	zRHFLdSyOFa98HPyUmNzIL2Gf440igV6CKRnLbOjy5SyLdTScKTRnef5n7WP7nf7
	0ycKhQRwT7HvGPWkaAOdQFUGagb073o7Z6R3zyknWd/ukp99+YuBx6X0oriOUDeB
	1qNitQ==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h09x4snf9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 15:00:08 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93bfb2da664so1215842285a.1
        for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 08:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790694008; x=1791298808; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oC6ycxct5evGf7msqSYvksrjwR+3Ojl2H7PIOG3pGA4=;
        b=koNk45XHtphmUWXgUZWwfIPIUProhxoehyItYhftB++HtfObCgELMYNaHKDiAQsitm
         ORaRaeDKk1km8tRrdfX1Un2SzlmPWIfSHOenOPazKlaM7NcALaVYiewnoafVaqtyDzpk
         qScoDePzRAK2ZlWI4hzyM3HaeB6LRGaDldOkOmhOMVBFAzH6WyBqGvsVRTlih++gZuZX
         80zZoA0O9//KTK2gdMi7UqLX20pm3IaYpfYeOPJR1iuxEYG8Znj0ZC9yhmisfIhoe55k
         pi34SVbMTPUiZfKpuHZBg21o83y7FYnLrEUp4R/zSH1+4AGlQ/6a30z1B/hlmru9roLI
         cHJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790694008; x=1791298808;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oC6ycxct5evGf7msqSYvksrjwR+3Ojl2H7PIOG3pGA4=;
        b=LEYf+TT+cZSoyvjO9MsuCVtbF6ddpAP7ffn3d+qY+Y4ivB+Xr5FbGYEPh5nFuTiO0m
         yHGypdOlMn7gT027mN0xcbOZ4jY+j7TcUZGB0SRDzJ3P9XdtzkVNRAMiZS9u6wv4kjHa
         KCLV5oM5FDGgGs77ZZB3dt/TG9szMrnMB6nNjA9dcJi64E7uIgcqXDzI6hfml5yg6Qhk
         JFJZCHSN0icy/vcviVpGG+WRna1HfhVF1MusFemLc/bf+gYSiBvsi+NJYk+CClYqg8g1
         NEzithqqHEUUJFGWiblHOPcA1Rv3zFQra2iUhdYFBeljaXKJyF3ossJqRHs4dhdD5ika
         5Eeg==
X-Forwarded-Encrypted: i=1; AKwUvBxXGSCQDKHj7e0zgLO0TBdhs9iF4XNzjtHutRb8koCzOnmtx47AW3HP3mxV9VJZvPEI/75Y0zw=@lists.linux.dev
X-Gm-Message-State: AFuF++nhK/RNYvNHSR7XzHxs0WiTZ8SVv6x8M71QVOQ8s+afa/1E6aa0
	/BOoze6VZbUcM/ukLrhI4gZa5nZYCGpr1q5WW1P+byrdZUGsS86M499YUc5R+WlrmdpMCLr/u8E
	un4KNqbrH11R+C2G7prDUZVf7mdOVOaE2QvqlDY5dNPrhf6VXTnNLPEoXEiI=
X-Gm-Gg: AYBFou1B9GkDQDk5y+7WENflLSBcSyYVMlF7F+GZ/rnoCCDjSfZRWXvW8dcPexJQ4Dq
	j1qNYAYpqahuzD4k4rWpossE1Sw/QzGiwG7mPwqyiDlQ3QwGTDDeus/jiVNolpQmIRSVDENPnGC
	VElOMUHiKdEVZAxRJHzN/m002TVnpBzo3Ha4UgE5SPZYZTSTGXhj4dTv81TPWKI+bzxHYRc8O3q
	0fplD2WyY/AZuV79K5NVoyB/oeyB4WOGRVf4DDB/euiYjlojRgB5BtuXh/KkUyHmSEVYigU6mYw
	YVNgMd6qPxSO97p0gtxF45gc/CsYwran7lY3WDP3WJA9B5pr3Ju5/B7fAQSI4YTic1y8688HBey
	vGMQ/AQQt1TgoKxM6/K8FguJAIwDCfMmlAA==
X-Received: by 2002:a05:620a:4547:b0:93b:bc51:b40 with SMTP id af79cd13be357-93c47223f95mr2617134285a.2.1790694007746;
        Tue, 29 Sep 2026 08:00:07 -0700 (PDT)
X-Received: by 2002:a05:620a:4547:b0:93b:bc51:b40 with SMTP id af79cd13be357-93c47223f95mr2617120885a.2.1790694006945;
        Tue, 29 Sep 2026 08:00:06 -0700 (PDT)
Received: from [192.168.69.225] (pmd666.hd.free.fr. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a014217216sm760635e9.14.2026.09.29.08.00.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2026 08:00:06 -0700 (PDT)
Message-ID: <1391eb6b-b4e9-417e-a634-115fc1751166@oss.qualcomm.com>
Date: Tue, 29 Sep 2026 17:00:04 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 18/25] target/arm: add cpu-models-stub.c
Content-Language: en-US
To: Khushit Shah <khushit.shah@nutanix.com>, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org, kvmarm@lists.linux.dev, eric.auger@redhat.com
Cc: cohuck@redhat.com, peter.maydell@linaro.org, richard.henderson@linaro.org,
        maz@kernel.org, oliver.upton@linux.dev, berrange@redhat.com,
        abologna@redhat.com, jdenemar@redhat.com, gshan@redhat.com,
        skolothumtho@nvidia.com, sebott@redhat.com, armbru@redhat.com,
        philmd@linaro.org, yangjinqian1@huawei.com, shaju.abraham@nutanix.com,
        mark.caveayland@nutanix.com, ping@khushitshah.com,
        sandesh.patel@nutanix.com
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-19-khushit.shah@nutanix.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@oss.qualcomm.com>
In-Reply-To: <20260921123249.1708067-19-khushit.shah@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDA1OSBTYWx0ZWRfX6z7jkhFoxjO8
 rAI4Ge0EJUhYbiu/wjiOVUBq6R9Bm76FV7H87ULl8P6rOVDpvgXIzHli33PF/GZKSPR5h8leQVk
 ADCumnZcQ5uuEZh01QFqnXHMFVMKaCg=
X-Proofpoint-GUID: fjos9hrScOrOAD8hdlKy5BrVR_He-OWd
X-Authority-Analysis: v=2.4 cv=I5Hw19gg c=1 sm=1 tr=0 ts=6abbd279 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=4s3hRJSeHn4rkQlkrse1kQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=M51BFTxLslgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=64Cc0HZtAAAA:8 a=kBidzhC-Fu57bEbtvHYA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-ORIG-GUID: fjos9hrScOrOAD8hdlKy5BrVR_He-OWd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDA1OSBTYWx0ZWRfX+t4ybMQ522ww
 d3ZYmQLVAyRb/5OM6Hce1+G7vEWNpPHRhZc2W/oTDakuVd7VqiwfKOpygQSCR+WXs0i6PmZQ+o8
 c09MSPkz+jqDH847Xgra8YqIuGzKzqOhBOZOEwZhR3c+GVjnCy9TUDRG8WLS1qW9kSjKGk+iIkO
 iMcnbIDfe2MHfl+GUd7x+WLDZG9OQFlUDVdFEl2/IS7OIAcFNHLB0/YO2zK1C/GkPnO9hOzrc3w
 Oj3xu9cJlE5UPilBBDxOENuY30OSZ8sgEmHpdC+w0cfjjI2msrCub2+UL2w3Mnc/OO7CIGjPBlk
 2m0DjNP6lu5eOdOubV/8yX4NRjqtVDPdF0dSGz3YLEz0bjlmAUQdUUbyIuO2u5IfMYA4iI1rspc
 Sv1DlPINwuTHgcOL5S2wQezN+26F4WZDAKY/ek11veuKBVHFVJEcY3kjib+w/0T5L6zNS0jDahH
 aPYLhJjc7a2VAL10kmg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 clxscore=1011
 impostorscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609290059

On 21/9/26 14:32, Khushit Shah wrote:
> Add cpu-models-stub.c, which will be required to add QMP support.
> 
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>   target/arm/cpu-models-stub.c | 13 +++++++++++++
>   target/arm/meson.build       |  1 +
>   2 files changed, 14 insertions(+)
>   create mode 100644 target/arm/cpu-models-stub.c

Shouldn't be needed if guarded in qmp_query_cpu_model_expansion() as:

     bool named_model = false;

     if (kvm_enabled()) {
         named_model = arm_find_model(model->name) != NULL;
     }
