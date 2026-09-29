Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A016516148
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 15:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790694191; cv=none; b=A6fyLCcMR01e0eV9PNINRoeBtEM5Q/K9U5KrGp6/Yu2dXYwpfBKe97dpW3fAxCUTdEAITAelAQPSINOASrgL1gHcpZsI1I987Qc5ZFHsh8EMQmMKiT/uNB2rAOhn96jXtjKYQbZpN/7TUSx1I5YskwW7Rnieen02CPj1CQzZwgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790694191; c=relaxed/simple;
	bh=tipcNK39XScHaqOA98M4wTW6y+23a21h0tGmWcQHKMY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IlCUL0Jdd0rsJR0c64nX4UmIQr1zxLunHAcZdMY6F98koqA95aNfGQbbD3+Z6Wl0S8/zBnBMqKbQjqNPu++0OrdDrrvWx3jI0r7mrPexsMKrnzUmviRBGE6RJqUcALJ3Xu2byx3T0ro4v2ZRu4moGYfIpuZR86xFz/186kdxd74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=iWn3i+bf; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PlIce+90; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="iWn3i+bf";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PlIce+90"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TCqkpg611721
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 15:03:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	05Akc9GMnhequFmmilTTIdP4SVT+/WUgp356FieEbRs=; b=iWn3i+bf7e+NdglV
	Lswv28iLwyoPUpMcVzgn9ClvRoBug+TYNUxKJuVc+/cUjLojDVBlyraKVrBxLsSK
	SFoYbu9Ets04aN/T/e5CXh1EZRPgK89xwltldD8L1zy5pKLknHyswLrfp6hNKZyL
	GvIuQ7AgiU3+4FvolYibEdL4PGwd+bA7cu9hq0W0QRuwfgi0iqhgN7YpZkTNx4JB
	SO3O0ysIEPTdBHP+/hk0EYo9Zo/6vllnGRsnc2rAAOMTBjymXkVbFArzhKvk9OE5
	wuwJvdijP9iv0bV+KxqmwY2gPuo70Q2wqAXQIE8fDRQV+sGQkxKUqqxgX1v+S8i+
	UKNXWA==
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com [209.85.217.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h00s4urjb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 15:03:03 +0000 (GMT)
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-7989d8ef4a6so593210137.3
        for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 08:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790694183; x=1791298983; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=05Akc9GMnhequFmmilTTIdP4SVT+/WUgp356FieEbRs=;
        b=PlIce+90uWtCl7D9T1sxv5FrqFNw6fnAIWd/qLJ1QX63cYgvxpt72ggk928/dlG3ED
         6QdCTJOUYEjw63q9dQXe7sUUjVfKGTkpMyoGuLfeDzC5hqBm7LfQFbKb7TMAmC5Yds+6
         DVjaKnzDQtjE5gbxNMzHM06PK6eTvUUrUUR+eEFAup9g/Z9NOtFRjneygUX63/qcnA8V
         n0gfDrd2Vb0AG49rgwm+QbxMccU70SbkU2mMxYSCTO3RPZTsVOV6QEiZLLywG2VYxwQh
         pnW/9CRHwNXy2JL8/mNVfP+KRLC++gopq1ErAQ69zgrQR/mJ79tL/tv6io8r0TRRw3P4
         QHbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790694183; x=1791298983;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=05Akc9GMnhequFmmilTTIdP4SVT+/WUgp356FieEbRs=;
        b=CiU9MxygtqOSxohCKUrZViVpiKUFGO801dC3BLSSinjFs2rLgY1AH2TEP0SdOR5ck3
         RRFTCQ35X+moBB21FleShcuIvWi1DFNnrFBvYv0ls5ZJsE0/xHisjOAuFgCh289VK+Sp
         S8ZtaUsSfpBIhEUzNNNMTzzorC7fXX7eeEVJOrKBl9Drnml0JgcSfKL1s9TUZisL3eMa
         E+8Tl229zTSYW7Dj4aq+890CKO7Wntg8TPz7xz9q4Ptspw2UCi6pvtu6TotFSItaSJj5
         fMGw3Juqm1oh4i92ZAfLKXj4VnpnAqGMfP2ArBrWPw3eXErq6FoMjQgHex0pUdfLSQpH
         X2OQ==
X-Forwarded-Encrypted: i=1; AKwUvBzMrDm559gorzIa0G+igYcesFSJ9uIw3p7L6UwDKtENR8CTKePA7gzGCMXiQrOqYJUO67drIR8=@lists.linux.dev
X-Gm-Message-State: AFq9FYLM6j5EQQm/mO8FiRN+OFWmVDyEtO8PhQ9kD0Ibxr21yrVrnjhw
	ahMl2PnY4fkfeGZAkMjgNibdKi1wuLfU6ojBit0gOSw9vdVf2MwpAL2CoE/LVDsIj3t5Dx/I0pU
	H3JKWSLoXMaVUDFkcIMhv0k0eoSXUwc6efOjXRa6gHEMku1piqowcGD9yx70=
X-Gm-Gg: AYBFou3yL8GaR60wUIfBUD72mB30pDbMCJVReNvyZ3ZlTzYRpQWiJo3UkxWOy1LcaaM
	xB+zzCln/EEAR2AVbTpHxykbgilxlGPXJua8Tq9ihEm9i9l/oveKjcpJ4f6XVkapkyjSlcxVXqN
	tjR46A5EfU5nF63V3XlLNHxyGqg1oIEJHtleEa884Gw8nMQOTvoVl5E7Ff4aiH+Vb9skyVf5E7Z
	+OUKYfK5PseLgvLvIHP15mTQoZDC8Qlz25NEVtSJY9is+P4I4yTdocT1bcl3e6HShhJXX8PmVre
	06RAIIfJiHyKYLuSKqS27jke+pBHOGCb94TKeI651X03TPXZ5cQ3F1LpjgNmWBpLk9TJ8PezAk7
	7zbNkqQbOiNik4vlVpI3rvADQhAkkFvga7A==
X-Received: by 2002:a05:6102:f95:b0:7a7:198a:c2c6 with SMTP id ada2fe7eead31-7b1d76ab79bmr3387391137.36.1790694182666;
        Tue, 29 Sep 2026 08:03:02 -0700 (PDT)
X-Received: by 2002:a05:6102:f95:b0:7a7:198a:c2c6 with SMTP id ada2fe7eead31-7b1d76ab79bmr3387370137.36.1790694181933;
        Tue, 29 Sep 2026 08:03:01 -0700 (PDT)
Received: from [192.168.69.225] (pmd666.hd.free.fr. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a00cf9dd27sm85331975e9.2.2026.09.29.08.03.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2026 08:03:01 -0700 (PDT)
Message-ID: <90a6d2b0-f046-49d3-9a25-3dd459477943@oss.qualcomm.com>
Date: Tue, 29 Sep 2026 17:02:59 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 22/25] target/arm/kvm: add kvm_arm_get_host_isar
 helper
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
 <20260921123249.1708067-23-khushit.shah@nutanix.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@oss.qualcomm.com>
In-Reply-To: <20260921123249.1708067-23-khushit.shah@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDA1OSBTYWx0ZWRfX1gcu1O6N2lO8
 tnuqcimv5KcIHQLJhjJKf+R+TCW0XKPt5orU4Qi5k0Eq8NZmfTgjuw6AiTRaiVoEpOUEc0eGE4p
 vSyQVIJi+cmHEB/0UQSmQLYwTW+X6Ok=
X-Authority-Analysis: v=2.4 cv=ALbfqNVA c=1 sm=1 tr=0 ts=6abbd328 cx=c_pps
 a=5HAIKLe1ejAbszaTRHs9Ug==:117 a=4s3hRJSeHn4rkQlkrse1kQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=M51BFTxLslgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=64Cc0HZtAAAA:8 a=ioU-NUoMSKYkJ-EG2NEA:9 a=QEXdDO2ut3YA:10
 a=gYDTvv6II1OnSo0itH1n:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDA1OSBTYWx0ZWRfXzVZmF7rvtXY8
 2cK19HFReQcH5azqG89mV0UcrApB+vx7p9zIKdH9uYlDSBKcIM9npbJLzQ/8T6NJsfrVh8dXckz
 xzNXuqqt2EoGIHNXFLGlICZPv77EQ7wQcYzzMkiYOJnNNgcWzQER8oVPSoT77KZSMG2rRBeijTx
 BoyQMehTVh4vcMV/MOm/RLHRuyJR3npep3YlUUmgWVC/VGTWXb9phbEUUUp6sV3V5HMD0hV64NC
 FCSIt7wH4BvElo4L2v91YEU8wmaAwPnu5xRHcAqFju+eMLr1sopMOifbc9kwHklsHtFbttIsogd
 AtD8QsTeE4RoL3CxDTnj9ACuyUj5rL3/eWH7YBNQ/lNFoQF0zSz0zxCyjw5y6Lnr+uBO1zW/XVi
 XnZQqY2f7Aah7phKfOCQaecZAXqMNWuokLpcK0aGGuVtJgIsg/p63AyWQI3XqrdvCb1SyLpUB6Q
 qH1ZMX9ikhhR5vtWJig==
X-Proofpoint-GUID: cjA6epKU3Hf24w4ZMvuGib6s-BhNwREd
X-Proofpoint-ORIG-GUID: cjA6epKU3Hf24w4ZMvuGib6s-BhNwREd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1015 suspectscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609290059

On 21/9/26 14:32, Khushit Shah wrote:
> Introduce kvm_arm_get_host_isar() to provide the host ISAR probed through
> a scratch vCPU. It will be needed by later commits.
> 
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>   target/arm/kvm-stub.c | 5 +++++
>   target/arm/kvm.c      | 8 ++++++++
>   target/arm/kvm_arm.h  | 4 ++++
>   3 files changed, 17 insertions(+)
> 
> diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
> index c9cd47bf47..059a7afdcb 100644
> --- a/target/arm/kvm-stub.c
> +++ b/target/arm/kvm-stub.c
> @@ -151,3 +151,8 @@ void kvm_arm_field_get_supported_values(const ARM64SysRegField *field,
>   {
>       g_assert_not_reached();
>   }
> +
> +const ARMISARegisters *kvm_arm_get_host_isar(void)
> +{
> +    return NULL;
> +}

This stub could be avoided if using in qmp_query_cpu_props_info():

   if (kvm_enabled()) {
       host_isar = kvm_arm_get_host_isar();
   } else {
       error_setg(errp, "query-cpu-props-info requires KVM");
       return NULL;
   }

