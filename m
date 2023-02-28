Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2046.outbound.protection.outlook.com [40.107.104.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A512CA2
	for <kvmarm@lists.linux.dev>; Tue, 28 Feb 2023 11:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghSa7UMzpJ0YRgTmft42BxkLKmL2EqUycDbX7XarFvU=;
 b=SEFJRLLjCG8K6jWh6mJiDG/+TNBr7/z/KJGGhWfyzku/tlGxbb+CsZB5S+D13KMQi/3iJo1r7Jb+mPUxnRHyzQJmZwCBMSIHzmrd74vdwMRTmA7LbV7cEzPnbBHWTKfiE8vdEIBnBWbWRLdzRIpKhz1kdU/1lmu2tYQPgq+oyLo=
Received: from AM6PR02CA0002.eurprd02.prod.outlook.com (2603:10a6:20b:6e::15)
 by AS4PR08MB7653.eurprd08.prod.outlook.com (2603:10a6:20b:4cf::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 11:26:21 +0000
Received: from AM7EUR03FT054.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:6e:cafe::4) by AM6PR02CA0002.outlook.office365.com
 (2603:10a6:20b:6e::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30 via Frontend
 Transport; Tue, 28 Feb 2023 11:26:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT054.mail.protection.outlook.com (100.127.140.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.17 via Frontend Transport; Tue, 28 Feb 2023 11:26:20 +0000
Received: ("Tessian outbound 0df938784972:v135"); Tue, 28 Feb 2023 11:26:20 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 30f4775cc4ab5db1
X-CR-MTA-TID: 64aa7808
Received: from ce1daefa6bdb.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 3BF54723-C6BD-4048-8B9B-6D08BDA60BC1.1;
	Tue, 28 Feb 2023 11:26:13 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id ce1daefa6bdb.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 28 Feb 2023 11:26:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+wMNAJLZMxZ9a+G4aSKjTmN8N43RBfer89N505Lsy1uo9qgOJLTwjclLA8c4UIXf9ZDC8+RE+PvM3iOqAF23OQUYjKl4KhTjEQspl754uF/A2F5IGy36GctZwtqdkX8qwGtgX3KOH4SRPHSZsZ6IYNjpV44lMKjy/9WNlDop40RMut9HjPKhxtxl4pbVSjlkVLduppRpCIx5yt+e4KdnQn9TL5vEFZYbXjVSvKb+bOmsPp3hTXJ2T1V5dloBBKI1Mx5wi/27Xk/SvM2bCApgMqKSUtiVeHL3P520YJxjSqWMTnLuSnleRsq6TxuqxrlyjPMnuTo+UpFH9vR0zH5bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ghSa7UMzpJ0YRgTmft42BxkLKmL2EqUycDbX7XarFvU=;
 b=Gc54XtUeYZEN3cY35EAt9NUEtm4f3Jt1wmUYrY1IqVB5c5je69aB9SQv+duRSv/3fkr6pyPNr21Fzo8SuJiQx9Bd3H3+UKQy5Mv321vVLIG4lrf79NPXgCiuITg4J7P639aU8S58Cxfvq0Uv+JjKrs4GjikmDJS1pPNP++3kTp8Odyz5+kSa2Kif/Uzb0jA9iNA6O0JzbUKelrFzUDz7Cwf/BIQN/364QYlTeRptN85s4hGQHZZ19kKe2P2u76HjHY8WMOceDyVVNEu8uonaCnfuvcAHiv739hJwmlMfC3tJcWubeNpjL6/whYtj3yTXMRvAW83I409Gw0bU3mNvvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghSa7UMzpJ0YRgTmft42BxkLKmL2EqUycDbX7XarFvU=;
 b=SEFJRLLjCG8K6jWh6mJiDG/+TNBr7/z/KJGGhWfyzku/tlGxbb+CsZB5S+D13KMQi/3iJo1r7Jb+mPUxnRHyzQJmZwCBMSIHzmrd74vdwMRTmA7LbV7cEzPnbBHWTKfiE8vdEIBnBWbWRLdzRIpKhz1kdU/1lmu2tYQPgq+oyLo=
Received: from AS9PR01CA0021.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:540::27) by AM9PR08MB5874.eurprd08.prod.outlook.com
 (2603:10a6:20b:281::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 11:26:12 +0000
Received: from AM7EUR03FT017.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:540:cafe::7f) by AS9PR01CA0021.outlook.office365.com
 (2603:10a6:20b:540::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30 via Frontend
 Transport; Tue, 28 Feb 2023 11:26:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT017.mail.protection.outlook.com (100.127.140.184) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.17 via Frontend Transport; Tue, 28 Feb 2023 11:26:12 +0000
Received: from AZ-NEU-EX02.Emea.Arm.com (10.251.26.5) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Tue, 28 Feb
 2023 11:26:09 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX02.Emea.Arm.com
 (10.251.26.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Tue, 28 Feb
 2023 11:26:09 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17 via Frontend
 Transport; Tue, 28 Feb 2023 11:26:09 +0000
Date: Tue, 28 Feb 2023 11:26:07 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
CC: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<kvm@vger.kernel.org>, James Morse <james.morse@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu
	<yuzenghui@huawei.com>, Reiji Watanabe <reijiw@google.com>, <nd@arm.com>
Subject: Re: [PATCH v2] KVM: arm64: timers: Convert per-vcpu virtual offset
 to a global value
Message-ID: <20230228112607.GA18683@e124191.cambridge.arm.com>
References: <20230224191640.3396734-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230224191640.3396734-1-maz@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic:
	AM7EUR03FT017:EE_|AM9PR08MB5874:EE_|AM7EUR03FT054:EE_|AS4PR08MB7653:EE_
X-MS-Office365-Filtering-Correlation-Id: 81c5afc7-f47c-4c4b-1423-08db197e9df8
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 Yq1FXE1Q9BDsQl8DzJUpRbi6dNQ0Lr73HT/W+07ivEGP77t1Ig9Hil795/SVVlsAZsNcTv97Mfq17i6lqMeEVuLJhIEm1P1b5dVrYXKSQ6/02AkSNMAl8hwtnLAT5Ys4GjPQSMwoqwtxqE+CmmU9mIF04L7fERbNhKSOUAZ95BPpXNWSviPFLOSgLbPMUB0tv4piwuGyhb7+Rtj8Kd/dG7HniUNhZwBOuCkbKAVMMeAuKVntA0EB+SIHRvbZ4S9pL0zk4U6Bwh6ZfA0PIvmmPHMEm4RVy+6wqVMXlDavIiQ6db3h+V67I1qNMlxgrPO3G/bJO8DRQT+roCm33eWW79haiWn244espc86PqNDDOYmA/ahSWq6Cv6M0hQ06+OYcsGVI3yj2tFrtPOrTUYuRDzv5qO06R190159me+YpHtLhbs+saDII9RFLkgm5QOvSBw1J7f8+pqg9nu8Jb50SCYwGSdyKLzD6PZ9kHPXekQm35GOe+D23GiE1F0mTEHsTMk5Fw/TgGXZY7C+fioRJ5LGyy7StBqlEUrQ3OYuy6Kxxm+1RmZRG/fIZpeuR/8gBw/uxuSCcASg6Gpsy4QamxGLkLENHCaiztOOTnX5wUYedjKZHrzIYRl/oRjwI4vg1UN12XwSjl6RVijTbcLMgQxJNCmAWZu/4TY7lQl9dnswTCWOG6zROkRsC6OZfgfArHPW6UN8bYE8XTKIzv204TcVwW28uVUVtcOIBL/88HU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(346002)(376002)(451199018)(36840700001)(40470700004)(46966006)(7696005)(2906002)(966005)(33656002)(54906003)(36860700001)(1076003)(186003)(26005)(336012)(426003)(47076005)(70586007)(6916009)(8676002)(40460700003)(70206006)(4326008)(86362001)(316002)(82310400005)(5660300002)(83380400001)(478600001)(44832011)(82740400003)(81166007)(41300700001)(40480700001)(55016003)(8936002)(356005)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB5874
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM7EUR03FT054.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	94af7e76-49f6-4b9e-6806-08db197e98b0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	UMUWJFg/IbEmQCT9FFekAZAv5YRDTNENHFZmGFc59ZpFLYprjDKOonxy2YNrnwqLudopcV1yxV09nBuVLiyD8LEZDqmm9YgiaiOqwPmCLTpo5fX97PyUX5p4X0CKnlR42kyZoSRb45qdUrLpKqrkl5kuxr1R4lMGfEwHmosJBDSsdNA3JIuCK5VqWfcGtIePQMVDBBCu/7uG/my7TldGfdmsc82rWq6M5XyZm6ny10rzJxIeunvkmwhnTqAOl0XwatcITO3xpD2KT9RGRBNHQcWllInGlgybUSy1H/pAs3VKXXvpiCxO2/PPZ3Pr4Aj49mIser2QRao4T6W5ouZ4B9RQY7IPaNu7BWS7okc64mwVNplZEFobVLZHD+kecIAcOx/nnS1SJ3GYS0/cYAqXYMmpxUH9QgXLLT6Yc0p93Ue9yScTc47nLUjG6MtFpNTTFwza+lX5ZlePoJs2yx81wTxVfhFXUo/sgKHjYrFq3OIPgh+NYpKh7Wr5Bfmti8XKbwc0OPmiPAM8Xh1oW9QwQPhVVDohjVY2tE8VXQGPosF3DA64TzLX7+iSqHqKmKRiN+dl53i/9amcsFvDT6y4c7Fv1gmVM5Pa7kfcofwmzTEkuy+AD+7cuUGq0ZkO0HBeG9LufimTzDNXKec2AfEf9d2qVi5Ikq4myn3KaZcdsOCwd76MBoa/dW2yusCc4/UQ
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(39860400002)(376002)(451199018)(46966006)(40470700004)(36840700001)(54906003)(8936002)(81166007)(316002)(336012)(186003)(26005)(7696005)(33656002)(478600001)(44832011)(40460700003)(966005)(86362001)(1076003)(2906002)(55016003)(82310400005)(40480700001)(6862004)(82740400003)(5660300002)(70586007)(4326008)(8676002)(70206006)(83380400001)(47076005)(426003)(41300700001)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 11:26:20.8818
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81c5afc7-f47c-4c4b-1423-08db197e9df8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR03FT054.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7653

Hi Marc,

On Fri, Feb 24, 2023 at 07:16:40PM +0000, Marc Zyngier wrote:
> Having a per-vcpu virtual offset is a pain. It needs to be synchronized
> on each update, and expands badly to a setup where different timers can
> have different offsets, or have composite offsets (as with NV).
> 
> So let's start by replacing the use of the CNTVOFF_EL2 shadow register
> (which we want to reclaim for NV anyway), and make the virtual timer
> carry a pointer to a VM-wide offset.
> 
> This simplifies the code significantly. It also addresses two terrible bugs:
> 
> - The use of CNTVOFF_EL2 leads to some nice offset corruption
>   when the sysreg gets reset, as reported by Joey.
> 
> - The kvm mutex is taken from a vcpu ioctl, which goes against
>   the locking rules...
> 
> Reported-by: Joey Gouly <joey.gouly@arm.com>
> Reviewed-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20230224173915.GA17407@e124191.cambridge.arm.com

Fixes my mismatched timer offset issues.

Tested-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey

> ---
>  arch/arm64/include/asm/kvm_host.h |  3 +++
>  arch/arm64/kvm/arch_timer.c       | 45 +++++++------------------------
>  arch/arm64/kvm/hypercalls.c       |  2 +-
>  include/kvm/arm_arch_timer.h      | 15 +++++++++++
>  4 files changed, 29 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index a1892a8f6032..bcd774d74f34 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -193,6 +193,9 @@ struct kvm_arch {
>  	/* Interrupt controller */
>  	struct vgic_dist	vgic;
>  
> +	/* Timers */
> +	struct arch_timer_vm_data timer_data;
> +
>  	/* Mandated version of PSCI */
>  	u32 psci_version;
>  
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 00610477ec7b..e1af4301b913 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -84,14 +84,10 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)
>  
>  static u64 timer_get_offset(struct arch_timer_context *ctxt)
>  {
> -	struct kvm_vcpu *vcpu = ctxt->vcpu;
> +	if (ctxt->offset.vm_offset)
> +		return *ctxt->offset.vm_offset;
>  
> -	switch(arch_timer_ctx_index(ctxt)) {
> -	case TIMER_VTIMER:
> -		return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
> -	default:
> -		return 0;
> -	}
> +	return 0;
>  }
>  
>  static void timer_set_ctl(struct arch_timer_context *ctxt, u32 ctl)
> @@ -128,15 +124,12 @@ static void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
>  
>  static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
>  {
> -	struct kvm_vcpu *vcpu = ctxt->vcpu;
> -
> -	switch(arch_timer_ctx_index(ctxt)) {
> -	case TIMER_VTIMER:
> -		__vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
> -		break;
> -	default:
> +	if (!ctxt->offset.vm_offset) {
>  		WARN(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
> +		return;
>  	}
> +
> +	WRITE_ONCE(*ctxt->offset.vm_offset, offset);
>  }
>  
>  u64 kvm_phys_timer_read(void)
> @@ -765,25 +758,6 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -/* Make the updates of cntvoff for all vtimer contexts atomic */
> -static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
> -{
> -	unsigned long i;
> -	struct kvm *kvm = vcpu->kvm;
> -	struct kvm_vcpu *tmp;
> -
> -	mutex_lock(&kvm->lock);
> -	kvm_for_each_vcpu(i, tmp, kvm)
> -		timer_set_offset(vcpu_vtimer(tmp), cntvoff);
> -
> -	/*
> -	 * When called from the vcpu create path, the CPU being created is not
> -	 * included in the loop above, so we just set it here as well.
> -	 */
> -	timer_set_offset(vcpu_vtimer(vcpu), cntvoff);
> -	mutex_unlock(&kvm->lock);
> -}
> -
>  void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
> @@ -791,10 +765,11 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>  	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>  
>  	vtimer->vcpu = vcpu;
> +	vtimer->offset.vm_offset = &vcpu->kvm->arch.timer_data.voffset;
>  	ptimer->vcpu = vcpu;
>  
>  	/* Synchronize cntvoff across all vtimers of a VM. */
> -	update_vtimer_cntvoff(vcpu, kvm_phys_timer_read());
> +	timer_set_offset(vtimer, kvm_phys_timer_read());
>  	timer_set_offset(ptimer, 0);
>  
>  	hrtimer_init(&timer->bg_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
> @@ -840,7 +815,7 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
>  		break;
>  	case KVM_REG_ARM_TIMER_CNT:
>  		timer = vcpu_vtimer(vcpu);
> -		update_vtimer_cntvoff(vcpu, kvm_phys_timer_read() - value);
> +		timer_set_offset(timer, kvm_phys_timer_read() - value);
>  		break;
>  	case KVM_REG_ARM_TIMER_CVAL:
>  		timer = vcpu_vtimer(vcpu);
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 64c086c02c60..5da884e11337 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -44,7 +44,7 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
>  	feature = smccc_get_arg1(vcpu);
>  	switch (feature) {
>  	case KVM_PTP_VIRT_COUNTER:
> -		cycles = systime_snapshot.cycles - vcpu_read_sys_reg(vcpu, CNTVOFF_EL2);
> +		cycles = systime_snapshot.cycles - vcpu->kvm->arch.timer_data.voffset;
>  		break;
>  	case KVM_PTP_PHYS_COUNTER:
>  		cycles = systime_snapshot.cycles;
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 71916de7c6c4..c52a6e6839da 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -23,6 +23,19 @@ enum kvm_arch_timer_regs {
>  	TIMER_REG_CTL,
>  };
>  
> +struct arch_timer_offset {
> +	/*
> +	 * If set, pointer to one of the offsets in the kvm's offset
> +	 * structure. If NULL, assume a zero offset.
> +	 */
> +	u64	*vm_offset;
> +};
> +
> +struct arch_timer_vm_data {
> +	/* Offset applied to the virtual timer/counter */
> +	u64	voffset;
> +};
> +
>  struct arch_timer_context {
>  	struct kvm_vcpu			*vcpu;
>  
> @@ -32,6 +45,8 @@ struct arch_timer_context {
>  	/* Emulated Timer (may be unused) */
>  	struct hrtimer			hrtimer;
>  
> +	/* Offset for this counter/timer */
> +	struct arch_timer_offset	offset;
>  	/*
>  	 * We have multiple paths which can save/restore the timer state onto
>  	 * the hardware, so we need some way of keeping track of where the
> -- 
> 2.34.1
