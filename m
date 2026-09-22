Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D804A3F31
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 19:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790105536; cv=none; b=DygO4VPDSdi/ZJgH4yJNoc4ikKP+GpYtiWMlH00cQOd5P+YuZbthqo7RZHX1LwXFwYJR2jDaWB4K4eWngAKP/lBt9FsBVjynh4BFzL49KsF0NMeHvL8biKVHM6goeJozbcwGLrY60JddS6/akKaM3YVlZfxrCsma8DHXSUSQMTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790105536; c=relaxed/simple;
	bh=3x6/JyG2QRiEHjZ/xYj/5Qj4VWGdcUhP8IUq90zVg7k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m48j/zcd9chUxSs6wTKeF8i+iMQskunYpduCglFHpg0z4ra+GiXZ1k+gdDwnCGfML4oLzj2353vqWsUNXRWZvcuBi4uGDmtS/vdiJF6ksb87sH16aJ0zKRyhHuPA01Dlb81VlzJdMZVqunf6Yc1duIHtsYTADq7nOgJ7Zi8IOmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mCBOY85K; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=L8mY2pwO; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mCBOY85K";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="L8mY2pwO"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MI7vDc767702
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 19:32:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	66fYIWxsQudt93HBnJi2uy8V6Tpbsup06vZEiSMqw5s=; b=mCBOY85KbLe6Pzpu
	w5tm5HyGuUICD9mdEO3H8lTMZIUCpf8AFei1DXXS08QcLVEtJAxzdKRouWwQSc8h
	43rMJ5W1G/3/MVoZ2NVTiP/aQRMF77qEnmqQr2ICtHVBKx95XcXwwBBhZhzUNaZi
	4ndM2W/aTGtdu7zacVeMqWQ2F3VzLdj4PunQFUE+vprQYm/aptc2G6sRML9ovMWo
	yGS6qAyhXuNhOmXGFzD0eUXu9QZnEXJqdkkYXPyREtygffmSqExP88MnuZblKRRl
	XasuB15LtZUeR0l/fOncloKgrNSR+OdcY5agE8c8BwuZJn6mILvg5/4XKbLOSOWd
	p2gtXA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gupbqk3cc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 19:32:12 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-32850005b6bso170900eec.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 12:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790105531; x=1790710331; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=66fYIWxsQudt93HBnJi2uy8V6Tpbsup06vZEiSMqw5s=;
        b=L8mY2pwOpitCLDgupPqnFPebePfvX+Jc6diSCCHWoCiuEjk8riQ6iSmWtlh8cWFR7C
         y+qWLZR167CrUIOHrKQEwTnn2ABSgIiAKto/l4i3K/5t2945ONRFfbyo4Fmpc96JsqjO
         +RQeZO0L5VHFOttvO2TkUIrNclRCAyZICGPKZOd3WAnS+aNGAZ1GK/muNIg/cmQjRrM9
         DTIhw/qTtp+DzVKcJtSaoGV6HoGVE9Ko23417WTM2u8cLbqRa3eL3Gz2Os5R0F2DGtKo
         j/zazpWIZFeRb6C/rSdKEtq9t6zvrI4JI1KA7elkqRQ98bb2CDahAOaTlIBK1u9iJNYt
         75gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790105531; x=1790710331;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=66fYIWxsQudt93HBnJi2uy8V6Tpbsup06vZEiSMqw5s=;
        b=kNrMASxdSNFSXujxWRZkyCXzjsg87vPKYagaz+FdR/8Egb4I+5v3WwLThWjj50C2vn
         k9BF9VhHCC57Ml7fPTEDejMUrEV4mzzYAkov7vkTQnzuqCaK2DGtJVH8P3Muy/3LneY7
         7TUQ5rpTNa47tnGlNYtPq3YDEe0sSiJW2eOJp9ugl0BOn6ASkZLryTXAxMQKqgT6FPVK
         m/9K8t6DqLTZxOUVC1r2n2ImBROQTBPgTT7oUpeiEPzH0zUApmAyKRQxviBW34cosAJi
         7Jw9xozbO4iUBqYE2EMV+J3KrfwwFuTYQLZ95bPOXRPC359EZeWyN+EMAlQE7iJWoVlr
         RpcA==
X-Forwarded-Encrypted: i=1; AKwUvBxARgUY8OuS1vzy3FQdwuDSzDHIgM7ZalZEfXzlOPJxSV9yG8zIBRf2w0cyly+lbmyn2zwZEnA=@lists.linux.dev
X-Gm-Message-State: AFuF++ld1uL3xS0S471epzyl3p6lLWQaVBwBM0pjwUDQCcs1nX1cGpUs
	9gI2MxdUlSKfQEPh8y2laqrcltq9XNK1p3jl2imzBLh1wGieab81rokbCmWYuCtMRyiBXthlkzL
	TiojV+HZ+ZPXeUYI+l6dIl1ROL5OHg1rDlPYLELw7d51IQhGxjq/aGDlBmWM=
X-Gm-Gg: AYBFou2lx9lN7ptxEU9pXhtbvZPKmiYqr0ZhQKyCs/4F9A+Fz0zx3nHpFyTzc5L4pzJ
	O77HH01tNQ37I1RlOvnFTB53L1KNeLd+daxpJO1ttCu2U/B9yGY/ejoMrgzc7tcinYA7AcFwZwc
	x8Ay0QkJH8Tqpwqkd3GGfm8mRfG4E6jsC18VxExZUKJNqszOt+ZKN73E3aQj9gV0U5j5ViiL84+
	sJx6dea+te+M1doxbRJMfdxqmLjrH+LsnhI1xN/2T+B+4OubyzF9LREUVOfKJbrq0Yeg5CDwxaH
	MsMO6sxNGUKAV7jo0qpkJRfRPsrrvNoS/xST5BK3s7WF9TQvpGw4g9Xs3HVaiq9rOqbmCnVfDGF
	In6O4Li4ql1VDUiIxg3oWrDpsTrdQH0reTcdpSLluOZiG13n8fZI/1GE=
X-Received: by 2002:a05:7300:e9cd:20b0:33c:5cef:1b97 with SMTP id 5a478bee46e88-33e8c24ccffmr310624eec.11.1790105531296;
        Tue, 22 Sep 2026 12:32:11 -0700 (PDT)
X-Received: by 2002:a05:7300:e9cd:20b0:33c:5cef:1b97 with SMTP id 5a478bee46e88-33e8c24ccffmr310598eec.11.1790105530772;
        Tue, 22 Sep 2026 12:32:10 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e96358e2bsm386472eec.16.2026.09.22.12.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 12:32:10 -0700 (PDT)
Date: Tue, 22 Sep 2026 12:32:05 -0700
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
        Fuad
 Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v19 03/20] KVM: arm64: Include kvm_emulate.h in
 kvm/arm_psci.h
Message-ID: <20260922123205.000019b4@oss.qualcomm.com>
In-Reply-To: <20260920212845.707-4-suzuki.poulose@arm.com>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
	<20260920212845.707-4-suzuki.poulose@arm.com>
Organization: Qualcomm
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.51; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDI4NiBTYWx0ZWRfX1VD+gn3BmnVj
 Ph66+CDpEfqVZ5h0WjvRknUB9KGXLIm/CKTZfBGz/Us1lSEEv/ROPLJrmWATHOTvglDR5bAqRdn
 nkF8F1MoqqerUiIZRZMuL8MIveSIhnoHFIwLHG6lOxXLYQS64VS0OEqwtzW2iXPuMh+nBFZVnUL
 XP4KNAJ9dGcZV12zMDtWcdsy/5dIhzI/Yg0TxcKg6KaQ5mUvjXf0gVkqw1gVaBWPmGM51JqD8PC
 E03iRhl6z9wq24mCIn8xLb9eK7klYVHkhg66orPz2qyIhIbsrjK4RraVvHvKbVGgfWbn7Ald198
 I6xc2k34gWPxTVlVlCn6YIVT03Uh22NplsX2HxFiyGG3MbW9k6to7S07nuJKocans5WHWxSr0Jt
 5W3h4VOTc3Tzo5Sk0cDGfBaLJpuBd/S7wszhinIcD6ot8oAVlIQFBgUmYBtkOl06oRawuSfUp8M
 +J3Rbggy161JEbZ+/SQ==
X-Authority-Analysis: v=2.4 cv=FdaiV5+6 c=1 sm=1 tr=0 ts=6ab2d7bc cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=7CQSdrXTAAAA:8 a=20KFwNOVAAAA:8 a=EUspDBNiAAAA:8 a=NCrhtLsLQcMXYuDHnY4A:9
 a=QEXdDO2ut3YA:10 a=6Ab_bkdmUrQuMsNx7PHu:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-ORIG-GUID: eULRM_tguB3ddD78Xirn8gDNzjl1GhFi
X-Proofpoint-GUID: eULRM_tguB3ddD78Xirn8gDNzjl1GhFi
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDI4NiBTYWx0ZWRfXwX96+JxXNhpW
 5/CUlvjM3aeutrVX82R2DFhS9TpNM8kquOpu24OEaiFpMyo1TpyzQ7C5auXtiiGmmO1RETIEXfb
 nEyc46oDnXJQkhlT9Wg7PguI4AhRD8s=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220286

On Sun, 20 Sep 2026 22:28:28 +0100
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:

> Fix a potential build error (like below, when asm/kvm_emulate.h gets
> included after the kvm/arm_psci.h) by including the missing header file
> in kvm/arm_psci.h:
>=20
> ./include/kvm/arm_psci.h: In function =E2=80=98kvm_psci_version=E2=80=99:
> ./include/kvm/arm_psci.h:29:13: error: implicit declaration of function
>    =E2=80=98vcpu_has_feature=E2=80=99; did you mean =E2=80=98cpu_have_fea=
ture=E2=80=99? [-Werror=3Dimplicit-function-declaration]
>    29 |         if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_PSCI_0_2)) {
> 	         |             ^~~~~~~~~~~~~~~~
> 			       |             cpu_have_feature
>=20
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

Seems like some of these precursor bits would ideally be picked up
asap - though that does confuse the LLM magic.

> ---
>  include/kvm/arm_psci.h | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
> index f86a006d67136..06c20612e9e7d 100644
> --- a/include/kvm/arm_psci.h
> +++ b/include/kvm/arm_psci.h
> @@ -10,6 +10,8 @@
>  #include <linux/kvm_host.h>
>  #include <uapi/linux/psci.h>
> =20
> +#include <asm/kvm_emulate.h>
> +
>  #define KVM_ARM_PSCI_0_1	PSCI_VERSION(0, 1)
>  #define KVM_ARM_PSCI_0_2	PSCI_VERSION(0, 2)
>  #define KVM_ARM_PSCI_1_0	PSCI_VERSION(1, 0)

