Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2084.outbound.protection.outlook.com [40.107.241.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5B5134A3
	for <kvmarm@lists.linux.dev>; Mon,  4 Mar 2024 07:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.241.84
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709536859; cv=fail; b=JqrMboQ2LYXJ5GgKuvkyVMqzWFjxiU/qcFM4ZtZrW0aD44FCDzYIZFhaqDiPzzy7lA4mIj+sdRSRDVB9Dxhq4UfjP7zDzrdKZYPhyhdUGRnudBq2yraRC6hZTVWOqdljeeHZYN7cfkXndS7ARWYPUIEGxLA1GipXJ6WaJb7cryY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709536859; c=relaxed/simple;
	bh=WPoTwCTsFjn34trcRlzGCnCPBYVZ51ZL+HFFEWfGSug=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nKOmEN39QldNrVQ87ndugmao+6hVnDsvkI6T8vDlCy/N6h7PNkLyaXgERT06HXg/KAVWStcZCX0cdbIK6Gfl2ytwHvAKF7V5l5qmb6JlC5QYOpGRbBf9CRy1D8hSiV7CyoJGY/MzAF1pY/nNED+P/AA6Dl9cNjuR21zNmhPGRBE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b=HjvASZJZ; dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b=HjvASZJZ; arc=fail smtp.client-ip=40.107.241.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="HjvASZJZ";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="HjvASZJZ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=YAbBABOnTBSzi/ogNmff4Q0Kw+38r6V+gwDLW5lDHaAXcYBUAxbpl7TXJpyth2hRqdkUn0KZFUgHW9X1DUtDtIt8X0z9qkVMf12kVeTSIFk79soT9Lb2wEeTxEb/jkF4LLlHgH616jZxSk0Twp5rON6qlsNdOk78K8kuogMkj6Avi8b1dKUpTGAe0v/nnLn8QVPBG0w44VaHayRyy414UE+jnQT166MDQFt9jE3zH7PY3vdSDY+aqr0LeMBHPDU0CQUkOuohiExh4RDFMVr8y+14mYWcRvS9TfcxQU71fEkI7g6CM4ktFbPcX7tmRbKHxqBkAR1w4cyPrlXfjCJ41g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XXSuWdxB59W2qJeUV8a5Nw0drObG4+zwNZc8Vl76kwY=;
 b=fQL2YD4wrXDtjbbY2uuVT/19MPBKvq+uhqNJJCeGyjc/HRBFUst/CYAP4ex8am4/YCzb+1VgJWa+GbSwfWzdGIjHi2BFuCdEaWZo9RvyicoVIvm4fH1QAUo6cZIsbNmngU/mvPiJHZrtFn/eXGPoIcwkg9mJg9Ms1jc4iM+89kQ3FBnMXu6quS7VI8fgF8AA4yP68qT6IjbJ2AzdolgbGpW77e0uzrsmdLiIHM9VaGpiqabuwN1DHRIvCl2xhZgpiucGXqs5EFyL6WV9pgVOZniq8RFp88JtPSUDuBVE9gLDKcyWicn0Z3sBiY7NTOH6B0IU3Qe46MBd/o3DAt/yVg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=armh.onmicrosoft.com; arc=pass (0
 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XXSuWdxB59W2qJeUV8a5Nw0drObG4+zwNZc8Vl76kwY=;
 b=HjvASZJZQO6lmzj1ziLdcjykN0jwIfjBbtnekwSqhmMoIjSko97Ejtc2YrAS0gglsCTDMYYZTZ0oCz3DVJNOag4mGBvX58OCoe+vAh8GluN/8xKs/L1OztUk009XVI0Lv6048xxV48dKqPFIDX+gS7h/Q5vbuytiz+E6J17EDxY=
Received: from AS4P191CA0016.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:5d9::11)
 by PAWPR08MB9122.eurprd08.prod.outlook.com (2603:10a6:102:342::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Mon, 4 Mar
 2024 07:20:52 +0000
Received: from AM4PEPF00027A69.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d9:cafe::d9) by AS4P191CA0016.outlook.office365.com
 (2603:10a6:20b:5d9::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38 via Frontend
 Transport; Mon, 4 Mar 2024 07:20:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM4PEPF00027A69.mail.protection.outlook.com (10.167.16.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7362.11 via Frontend Transport; Mon, 4 Mar 2024 07:20:51 +0000
Received: ("Tessian outbound c21fe6ca13cc:v228"); Mon, 04 Mar 2024 07:20:51 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: ff437af2a78c815b
X-CR-MTA-TID: 64aa7808
Received: from 2ac324b2b3ed.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id BE27D57C-7BC7-4A90-BF4A-134A48B12624.1;
	Mon, 04 Mar 2024 07:20:40 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 2ac324b2b3ed.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 04 Mar 2024 07:20:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V6KOYXmJ+9c2QA+IcbA1bvsu/Zy6GDIk7N22K26MhpZT5Vrd8d4XOd7iO4ZjSUBXdEdJqIyVgWvNLSAs97PXaSZdzapBC9Mk+IGbK0DiEqgB0XViGgXNWPLqlcGzJX3+QPPgx/VfmQJ+uiooKr+Mo2+/pTYc2bN4sIHYrRog1inf+lZICC19OFWWs4YiUCV1axJtgco9jE95Ohq0nXAfmpYogW+eUhfqyssl+vEQKWDHuI1g4sIBnw54oJn9c+ogvwsqo9KgTWBcRm141IFze9Znu8vqxhX2y8mDgH6aRUfpGy4MBKP9sFL2tRbBf+nC0ymGGzWZbn+IVbsdpP3m3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XXSuWdxB59W2qJeUV8a5Nw0drObG4+zwNZc8Vl76kwY=;
 b=YwJPrA7QAGtIYXlmG9Q7IiMQXaF0al5etgG54G04tw7Y+1Z3ZUU9Cn/0ELPCFET0VsrMy3iMhdk21vi6wKS+LlwSMvVnnjHF8IxSMg7YIZAq2Pe8EnDi3fYznJx+V+HaHiO0tJoYRAYv0Tl5hXjwWVmzWPIL7AbDRU4AWQu6qJEySdCGpl3q2yT1Jvo/JwSM3wy5iE1ZPmaYhfjPBRNMnhmrEqS2Z53lFCtme/WgPdx0ePbHMWtqOzLnEg1t9cKYwEuhMJ336D/ADD27OO9+VDp/KUxjtngSkeyUpbKj05d/LTTNJJtdQFn6CfT6AclQkwdbANyoxTTv6XTsMJeJlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XXSuWdxB59W2qJeUV8a5Nw0drObG4+zwNZc8Vl76kwY=;
 b=HjvASZJZQO6lmzj1ziLdcjykN0jwIfjBbtnekwSqhmMoIjSko97Ejtc2YrAS0gglsCTDMYYZTZ0oCz3DVJNOag4mGBvX58OCoe+vAh8GluN/8xKs/L1OztUk009XVI0Lv6048xxV48dKqPFIDX+gS7h/Q5vbuytiz+E6J17EDxY=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from PAXPR08MB7017.eurprd08.prod.outlook.com (2603:10a6:102:1df::21)
 by DU2PR08MB10085.eurprd08.prod.outlook.com (2603:10a6:10:496::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Mon, 4 Mar
 2024 07:20:37 +0000
Received: from PAXPR08MB7017.eurprd08.prod.outlook.com
 ([fe80::ff7d:ae5d:bc51:66fd]) by PAXPR08MB7017.eurprd08.prod.outlook.com
 ([fe80::ff7d:ae5d:bc51:66fd%4]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 07:20:36 +0000
Message-ID: <92be0466-eb29-40f5-8313-d1b6326a6727@arm.com>
Date: Mon, 4 Mar 2024 07:20:35 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 07/18] arm64: efi: Remove EFI_USE_DTB
Content-Language: en-GB
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, shahuang@redhat.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240227192109.487402-20-andrew.jones@linux.dev>
 <20240227192109.487402-27-andrew.jones@linux.dev>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20240227192109.487402-27-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO4P123CA0538.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::8) To PAXPR08MB7017.eurprd08.prod.outlook.com
 (2603:10a6:102:1df::21)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	PAXPR08MB7017:EE_|DU2PR08MB10085:EE_|AM4PEPF00027A69:EE_|PAWPR08MB9122:EE_
X-MS-Office365-Filtering-Correlation-Id: df933981-58f4-4f0c-f815-08dc3c1b9f7c
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 95xpR97vKEMUz+XBqbiCDIoD+LIUvtp3dq/IZwGT0wwRAYe0mSw2x10pPu1WCjNyR0mf+bLW7WYbCt+iQRj5V/QlOuqsfc1ihKrvYX4LP82hRsJdyjm2DpotJDulNz9TNcFu9nAbz+x/ltjxZ0uZIzWqsgIm2CXK7QO6KgTJb+1gQWmS4s6zCO9ekQmF8gYqUslRh+yarodLPOUpH2kj3O+V8k2yELk5ARR58CH+S1vOHOQa/EMUN4IxSHBtwKoQpxzP4larW1zW1JXt2YpPm4W3UIR8TpqPkc+UEPav5m0Dv9ZCaI98eY2RwSrFxM6vqpsKAP4DfPeSWfRqjQeYvwSFM0uabyR3zjfoJ4Y1Xsqqy/xVKxk7ssp+FCyMj2RYhctn3JWTrLSmhBbPEpV6ASP9CDM716J1tgsAbK+sZW0JHvhZNhl1KXHlfpPnkorVhxbEPDxjPsLR1cqGuGKuzzDsVpKWOWMaOJiPd23xnBBxAB1YAvn2xLdzna9UeZIy9l/Nxr4PJD2yncHFLnvoHkggTntfp+z+7sY/tgJOv22eBTuaouLGTV+skuNWjuShWm96uqVgB6gN90V/uzE1iabDyWJSZsnZ50yLA28OVe539YLYyWHNyN7On9faM86SL9CVlQUu9YsYokoFjVWNenmmWbYf/1HFupoYFP0q+DA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR08MB7017.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB10085
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	60c2096f-9754-4b2d-67d4-08dc3c1b965c
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3x4LKvawX452hV3pPXyNltm0hIMEeBUr0SBH2uOeCKYt15KJiQYeDz7cexOruQ8pxED6YR96aXlqGCsScHv2U3ugHkFHJBU2JZFnln5LK+6sS+w/VdScIfnQLFwzHzicoHQ74h5DzQsyiUo9zpd/huINn7R9Bv/sJK6P1H+5yMpx0LHi+tUt2YlorO3DVyDJiIeiKXKok8w+pMPdyWhdmWrGl7l8Hjpv8g9JcKaAVAGV5Hw2R3S23Vg4XbqIfzUh5Y9F1KCPBJkx8twnEBdF475/2V7PKoK9lyBAZ0ceTyUEfd3TMo0ekXyBN6ge5rPX2XHwIiOpeVziMaCFbg4Y9BvW4hNOmTvNq06xejo+k2DkGfS4MF0xXB3k8cXSXSo/QdpjYIGnv2ptCze2eqzIXC6oaJ3Jpb9/qAUmz9nGahQ0X1CZEF5DfDUWrrG6lpIbYcS4aYoMl71mNb8m6E8yZz59n+bRzDcQ72KP1/w2a0CdHGBbsDJ3z406qavveBmX5vOCPatIQFaUxLIRox4kOaRw+IpINfLHl/r2X3zUNvmUUjgCI1cbnygBoqLSLgVQvQgufT30qICcUcipxqCllW2aew2fTwd/ZxLh2eXla80GUMuVY1+KfEyBL8JM5JjyG7nF6UfL+Kva0LqD8BTBEUpPW0/alchSA4HdVu/NBlbTiKD9T0HzuUCpG3+QxNQ4l/Hx3PWtg/Z53aCUiKfLCdS3OadSHo6LQDQ2XFDSg4es/woAmAHCyIrW6LyqMx+X
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230031)(82310400014)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 07:20:51.6693
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df933981-58f4-4f0c-f815-08dc3c1b9f7c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9122

On 27/02/2024 19:21, Andrew Jones wrote:
> We don't need two variables for one boolean property. Just use
> !EFI_USE_ACPI to infer efi-use-dtb.
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

Thanks,

Nikos

> ---
>   arm/efi/run | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/arm/efi/run b/arm/efi/run
> index 494ba9e7efe7..b7a8418a07f8 100755
> --- a/arm/efi/run
> +++ b/arm/efi/run
> @@ -27,8 +27,6 @@ fi
>   : "${EFI_CASE_DIR:=3D"$EFI_TEST/$EFI_TESTNAME"}"
>   : "${EFI_VAR_GUID:=3D97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823}"
>
> -[ "$EFI_USE_ACPI" =3D "y" ] || EFI_USE_DTB=3Dy
> -
>   if [ ! -f "$EFI_UEFI" ]; then
>       echo "UEFI firmware not found."
>       echo "Please specify the path with the env variable EFI_UEFI"
> @@ -68,7 +66,7 @@ uefi_shell_run()
>       mkdir -p "$EFI_CASE_DIR"
>       cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_DIR/"
>       echo "@echo -off" > "$EFI_CASE_DIR/startup.nsh"
> -     if [ "$EFI_USE_DTB" =3D "y" ]; then
> +     if [ "$EFI_USE_ACPI" !=3D "y" ]; then
>               qemu_args+=3D(-machine acpi=3Doff)
>               FDT_BASENAME=3D"dtb"
>               UEFI_SHELL_RUN=3Dy $TEST_DIR/run -machine dumpdtb=3D"$EFI_C=
ASE_DIR/$FDT_BASENAME" "${qemu_args[@]}"
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
