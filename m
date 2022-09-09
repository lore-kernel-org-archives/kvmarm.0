Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E88EECAAD3
	for <kvmarm@archiver.kernel.org>; Sat, 10 Sep 2022 14:24:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF38B4C02F;
	Sat, 10 Sep 2022 10:24:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@quicinc.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S1WZAVamaI5C; Sat, 10 Sep 2022 10:24:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3B3E4C014;
	Sat, 10 Sep 2022 10:24:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF13F4C114
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 14:16:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nd29WVNW9cxv for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2022 14:16:55 -0400 (EDT)
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com
 [205.220.168.131])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 256E34C069
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 14:16:55 -0400 (EDT)
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
 by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2898XvbQ025807;
 Fri, 9 Sep 2022 18:16:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com;
 h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=tuPPrucYTqpGq1jfSQ7TV8M2XN0vfz8dVieMxM7ko4A=;
 b=UCmE0QGLk/CNeriQOsgAoEfCNTW5CRPoWW6ozH1zRCbS0KRNk0GVzi8v32iN+oqFTNRU
 +zcyfaC8qUmBufutOsho8jtKhXG6mJQ2/2XEUrnAEe/5qnXTneaGPLJ1IiuRgHOHfm0A
 z7yr2xfp1Es0aHZsY9WQXFULaPNkpnYDrXF3lQbmET4t6akjYvBIWTCdKVtoHkNmBKxv
 5GjG0Us83aO2nF+hZN5pOZwLBjgNoEDX2eGo7M+pCs+GtiqtII0i2Gi/j4+weUDdwyi/
 RU7DmOPPPXjztWgjZ1s+3IFOa47x1VXPIZ6UcqjQglA4aW88lsur6dAxNd1jziY2SqGT FA== 
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com
 [199.106.103.254])
 by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jfcpbxewm-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Fri, 09 Sep 2022 18:16:49 +0000
Received: from nasanex01b.na.qualcomm.com (corens_vlan604_snip.qualcomm.com
 [10.53.140.1])
 by NASANPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 289HtK8u015807
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Fri, 9 Sep 2022 17:55:20 GMT
Received: from [10.110.45.139] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Fri, 9 Sep 2022
 10:55:19 -0700
Message-ID: <05057e2a-1a85-69ba-ffcd-584d4090467a@quicinc.com>
Date: Fri, 9 Sep 2022 10:55:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2] KVM: arm64: Only set KVM_MODE_PROTECTED if
 is_hyp_mode_available()
Content-Language: en-US
To: Catalin Marinas <catalin.marinas@arm.com>
References: <20220909144552.3000716-1-quic_eberman@quicinc.com>
 <Yxt3wmXYYbWraXrd@arm.com>
From: Elliot Berman <quic_eberman@quicinc.com>
In-Reply-To: <Yxt3wmXYYbWraXrd@arm.com>
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800
 signatures=585085
X-Proofpoint-ORIG-GUID: AP-y2F3XMGyeOnd-nJxqrgPW6E8z7YUm
X-Proofpoint-GUID: AP-y2F3XMGyeOnd-nJxqrgPW6E8z7YUm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-09_08,2022-09-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=685 lowpriorityscore=0
 malwarescore=0 mlxscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209090065
X-Mailman-Approved-At: Sat, 10 Sep 2022 10:24:17 -0400
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



On 9/9/2022 10:28 AM, Catalin Marinas wrote:
> On Fri, Sep 09, 2022 at 07:45:52AM -0700, Elliot Berman wrote:
>> Do not switch kvm_mode to KVM_MODE_PROTECTED if hypervisor mode is not
>> available. This prevents "Protected KVM" cpu capability being reported
>> when Linux is booting in EL1 and would not have KVM enabled.
>>
>> Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
>> ---
>>   arch/arm64/kvm/arm.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 8fe73ee5fa84..861f4b388879 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -2272,7 +2272,9 @@ static int __init early_kvm_mode_cfg(char *arg)
>>   		return -EINVAL;
>>   
>>   	if (strcmp(arg, "protected") == 0) {
>> -		if (!is_kernel_in_hyp_mode())
>> +		if (!is_hyp_mode_available())
>> +			kvm_mode = KVM_MODE_DEFAULT;
> 
> I think kvm_mode is already KVM_MODE_DEFAULT at this point. You may want
> to print a warning instead.
> 

Does it make sense to print warning for kvm-arm.mode=nvhe as well?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
