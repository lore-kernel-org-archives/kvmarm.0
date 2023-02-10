Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2078.outbound.protection.outlook.com [40.107.20.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BD863AF;
	Fri, 10 Feb 2023 16:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rjy4mcPXP8vt5mWXGqpoYHpyJBstqkvv/BuDH6meLOw=;
 b=Lowsx0n2HVo+VHgKpg7xPe2y+Lt2PrUpVqn49kC8M+cIgGhwz0sdkqCerqlwoykDrSkqs+JF5BQK3bCOTtZ+7WgaHzd7U0m4hSsF1xBAWBrLmFA8XOi1FzMw3/sL4RqLvrPFThcCg1a5zZUPGPthX7tSxP/d7ywu4bGmXe9nlnA=
Received: from DU2P250CA0030.EURP250.PROD.OUTLOOK.COM (2603:10a6:10:231::35)
 by PA4PR08MB5887.eurprd08.prod.outlook.com (2603:10a6:102:f2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Fri, 10 Feb
 2023 16:51:26 +0000
Received: from DBAEUR03FT016.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:231:cafe::b) by DU2P250CA0030.outlook.office365.com
 (2603:10a6:10:231::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19 via Frontend
 Transport; Fri, 10 Feb 2023 16:51:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT016.mail.protection.outlook.com (100.127.142.204) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.21 via Frontend Transport; Fri, 10 Feb 2023 16:51:25 +0000
Received: ("Tessian outbound baf1b7a96f25:v132"); Fri, 10 Feb 2023 16:51:25 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: fe34fbb3a1dc5c89
X-CR-MTA-TID: 64aa7808
Received: from ccf8bd0d0d28.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id F7305835-A85D-4BC1-B9CF-2A06F9CA64A3.1;
	Fri, 10 Feb 2023 16:51:17 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id ccf8bd0d0d28.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 10 Feb 2023 16:51:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n3DXaaSbXBjYVFdQxA6icVBnt/sRMLJBQtu0Xslz4mNpY6f79zsic26JHUhMm3sqMSvfkWwkAgv+YrWebrzDFsgPsP/UDt4+G6krKvK6EPu7Y2MJpjiXrtd4z2FYPX1b/g3v78N/APfI/moopTMrikCeTDfGirVJ2Quq8QAQndiKzb2VHEMJA79NcEKvDond4J4GJ/QMk2Uz9HwOtV1IiMT+s7FHXMoip+G6QV7ERVgKAIhlWrb/HYrN7Dv4l3SqABRSpSJfM/Nd+8ag/dC0l0ScLjEFwuN1biXhpB+nA31S59aEcVncDKrtcm/QSL97xsAJEcfVfp1hmccvkAu+eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rjy4mcPXP8vt5mWXGqpoYHpyJBstqkvv/BuDH6meLOw=;
 b=br2mPp8bnrilkxVR+oGy1AnnxnBGlkQkTnoeV5356vANMAEWp4ElpTg9txkn+gnOc/zJL480OWkALn2d+lj7roScA4VjHtyY8R173EsbOg6Zwz8mLs01S4+HU60s+oBcY2TKjxrnv5xzWCC8iu7WdIRW2E/PRpvLwjGmOBOGTNbwS//BLaCI0L9y5R2Vq5neqGgex8FCaHv+XRaaPHzZtvvJYCkBp1lPxnfa3TdpuflJbk4AgFqNVzx8vNsd6dDcTNAuYABhfLPEOXaC+RcdH8woJKkFcoBQegSwGvj57njPsyIilxGs0hkq0ULpWXNO+dcfwxuiyxAhBKxVLfEX2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rjy4mcPXP8vt5mWXGqpoYHpyJBstqkvv/BuDH6meLOw=;
 b=Lowsx0n2HVo+VHgKpg7xPe2y+Lt2PrUpVqn49kC8M+cIgGhwz0sdkqCerqlwoykDrSkqs+JF5BQK3bCOTtZ+7WgaHzd7U0m4hSsF1xBAWBrLmFA8XOi1FzMw3/sL4RqLvrPFThcCg1a5zZUPGPthX7tSxP/d7ywu4bGmXe9nlnA=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB6995.eurprd08.prod.outlook.com (2603:10a6:20b:34d::13)
 by AM7PR08MB5432.eurprd08.prod.outlook.com (2603:10a6:20b:10b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Fri, 10 Feb
 2023 16:51:11 +0000
Received: from AS8PR08MB6995.eurprd08.prod.outlook.com
 ([fe80::ba48:cc43:1ad9:34a9]) by AS8PR08MB6995.eurprd08.prod.outlook.com
 ([fe80::ba48:cc43:1ad9:34a9%5]) with mapi id 15.20.6086.019; Fri, 10 Feb 2023
 16:51:10 +0000
Message-ID: <cfb0292c-e84d-0a7c-be74-ae5508779502@arm.com>
Date: Fri, 10 Feb 2023 16:51:07 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [RFC] Support for Arm CCA VMs on Linux
To: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 James Morse <james.morse@arm.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>, Quentin Perret <qperret@google.com>,
 Sean Christopherson <seanjc@google.com>, Steven Price
 <steven.price@arm.com>, Thomas Huth <thuth@redhat.com>,
 Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
 kvmarm@lists.cs.columbia.edu
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
Content-Language: en-US
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20230127112248.136810-1-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0587.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::15) To AS8PR08MB6995.eurprd08.prod.outlook.com
 (2603:10a6:20b:34d::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AS8PR08MB6995:EE_|AM7PR08MB5432:EE_|DBAEUR03FT016:EE_|PA4PR08MB5887:EE_
X-MS-Office365-Filtering-Correlation-Id: 96afdd2b-7352-4d2b-15e8-08db0b870c59
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 HAvuP95q3GcDuLa6wjVSukftxDcCZ8ys9ibvna1NJllCyDxQwa9D/TZCmTT8TxuTJF0ZS9kMoFzSbQN58rH+JGgt7h13O7yuIUEI82Y3Vn4WHc/0D/uI6o9+h6/BAeGA6iK5bwhBBBb/QvtJQ5wyHwHcQoyRwhuqjVTtfxwEj8d2bBT/z4cRZuWmzou6Ej/c1UMTC7Kzv8wvopA9AxdORRUy5vwBg6k41IIfKnwsna23Lykm7GOTCel9xNTaObHbQvAYPuV6RSWKwfKTZ756OvpKXWxLITKi51b2vh+THLTZd5THrO8vVoh5ITi8l6UZJo/hTwkPUjtlzKyPmldBQTfygjuDWswnsMJBO9WesuyZVmsw1yE8e0wh4+Eck7hhetzNBtbX+IKyI7ys5ltfFzzJU3ik2sTm7Wa7f//iLTALxH7NZPf3DoTfrIRCqS5TRmyM94/8gCCwn/UgbXriIHgP/+QNy4h4Q9yxfLTgjUtK+eO5stu9ac/qYuP7lnT25UVq8klM3Kv4wJRq3nd0Bu/mXWtimcx4JjYBmrn0L15LkN1FTUfO14I0V8uhF0cc95fH9FFZRlbCXWg3hjFFYWsHrbSa+CD7VlRN17HtY6JWKf39SmhWLKutTBIIl7jI0vyYfX2ORMqI4/3fYav9+nJ1H7MTdjDK7vshY+0DnxAVmMY9LP+3SOsPiRtB5+IThd7SG2sAdbV9NHbFy3xRYqXCYoqO5y4RfKkibKLd+NO0XSEg7nNJEnqwYGHp4AzTyK8ytj+vkunU+LY1e42E9tnSSPrxY2etntiaWA1U7g3pw+t965eennrzP22TKQY+
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6995.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199018)(478600001)(8676002)(966005)(31686004)(6486002)(6666004)(2906002)(26005)(53546011)(6506007)(6512007)(41300700001)(83380400001)(86362001)(66946007)(66556008)(66476007)(2616005)(186003)(36756003)(31696002)(44832011)(4326008)(54906003)(8936002)(5660300002)(7416002)(316002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5432
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DBAEUR03FT016.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	80097707-efca-4b68-b017-08db0b8702e9
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	FNNlZsQWZ5ujw5mZN0M18qDAidfZXenoepsloIxz0XM7p0mjIwpOAfO0aDcfK8BdUctvokpZYPdMYnesi//YprwNxyRMqFKhYla/j7xG4Ocq7aPBoZwBpm86ZrymyQkLh+Mzm0F3dwgr+Wuc5Act8bNSuyJh/k8E8c/yS1I1XsnAo8hxFZlvb6ZHG/IhaIyZzzM8u5AoXQC50Fb/GPaDO+t9DP26rjpb/wOVVl+eC+xQL1yEEy0h0j08hakbkGFnElBX/3j+toMTB1cBCZEFgu+XYiKUDXQarssnywDGcIM93Dg3Yqk06TzsbABrAusT7yATgjwBHyD6q1tVJG9z4ZJKkdJ4ZYyWOnWKcAoJDI6VWGrhJuDtNv1ONbq/30AkPlnzoygu5M1QVoZ6rpzecibQIq/ptbF473pbyT5RmZdwmdal38KVBPpOxTG2+TRf8zcvlntrDTpDLNAkudW9CuMBtHbAGQzOnj2vjMHhAqEnYlaq3Bjilg94RGgKu6lp8c9VGSRrYlONEI9t119H+kGmRKGv5vwb0Pl4DcdcU9MdpTIR63wlr0mkSXyTbw1DI3+wJUhrIoFvX1Z7kVxgFPwmN2sZ5Z0K6Bup1zA3zg6uCB+Yp5adCM67HJkM0SmHEZnE5NKyS5w2R7qQE1w5TAdbaZ909Dh6A3r1BWmo58/ZvhO+3axfIDoXRnIZKVMQX0btBdj3FJr30FtSwK38m7TBlh4UmJh45R8fQdADjKQ4AzFSO0CAAbXw6Kx118G7XlHzPlPQNURnHOhZxkVt1lnG4Z19VoLrvRmxZg9xAu3FInwaqmGVHbK/YOfZfo6c
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199018)(40470700004)(36840700001)(46966006)(31686004)(82310400005)(6512007)(356005)(83380400001)(54906003)(6506007)(40460700003)(186003)(53546011)(26005)(36756003)(6666004)(336012)(2616005)(107886003)(70586007)(70206006)(86362001)(8676002)(41300700001)(478600001)(4326008)(47076005)(31696002)(450100002)(316002)(36860700001)(82740400003)(81166007)(966005)(40480700001)(2906002)(5660300002)(44832011)(8936002)(6486002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 16:51:25.8400
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 96afdd2b-7352-4d2b-15e8-08db0b870c59
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DBAEUR03FT016.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB5887

On 27/01/2023 11:22, Suzuki K Poulose wrote:
> [...]

> Running the stack
> ====================
> 
> To run/test the stack, you would need the following components :
> 
> 1) FVP Base AEM RevC model with FEAT_RME support [4]
> 2) TF-A firmware for EL3 [5]
> 3) TF-A RMM for R-EL2 [3]
> 4) Linux Kernel [6]
> 5) kvmtool [7]
> 6) kvm-unit-tests [8]
> 
> Instructions for building the firmware components and running the model are
> available here [9]. Once, the host kernel is booted, a Realm can be launched by
> invoking the `lkvm` commad as follows:
> 
>  $ lkvm run --realm 				 \
> 	 --measurement-algo=["sha256", "sha512"] \
> 	 --disable-sve				 \
> 	 <normal-vm-options>
> 
> Where:
>  * --measurement-algo (Optional) specifies the algorithm selected for creating the
>    initial measurements by the RMM for this Realm (defaults to sha256).
>  * GICv3 is mandatory for the Realms.
>  * SVE is not yet supported in the TF-RMM, and thus must be disabled using
>    --disable-sve
> 
> You may also run the kvm-unit-tests inside the Realm world, using the similar
> options as above.

Building all of these components and configuring the FVP correctly can be quite
tricky, so I thought I would plug a tool we have called Shrinkwrap, which can
simplify all of this.

The tool accepts a yaml input configuration that describes how a set of
components should be built and packaged, and how the FVP should be configured
and booted. And by default, it uses a Docker container on its backend, which
contains all the required tools, including the FVP. You can optionally use
Podman or have it run on your native system if you prefer. It supports both
x86_64 and aarch64. And you can even run it in --dry-run mode to see the set of
shell commands that would have been executed.

It comes with two CCA configs out-of-the-box; cca-3world.yaml builds TF-A, RMM,
Linux (for both host and guest), kvmtool and kvm-unit-tests. cca-4world.yaml
adds Hafnium and some demo SPs for the secure world (although since Hafnium
requires x86_64 to build, cca-4world.yaml doesn't currently work on an aarch64
build host).

See the documentation [1] and repository [2] for more info.

Brief instructions to get you up and running:

  # Install shrinkwrap. (I assume you have Docker installed):
  sudo pip3 install pyyaml termcolor tuxmake
  git clone https://git.gitlab.arm.com/tooling/shrinkwrap.git
  export PATH=$PWD/shrinkwrap/shrinkwrap:$PATH

  # If running Python < 3.9:
  sudo pip3 install graphlib-backport

  # Build all the CCA components:
  shrinkwrap build cca-3world.yaml [--dry-run]

  # Run the stack in the FVP:
  shrinkwrap run cca-3world.yaml -r ROOTFS=<my_rootfs.ext4> [--dry-run]

By default, building is done at ~/.shrinkwrap/build/cca-3world and the package
is created at ~/.shrinkwrap/package/cca-3world (this can be changed with
envvars).

The 'run' command will boot TF-A, RMM and host Linux kernel in the FVP, and
mount the provided rootfs. You will likely want to have copied the userspace
pieces into the rootfs before running, so you can create realms:

- ~/.shrinkwrap/package/cca-3world/Image (kernel with RMI and RSI support)
- ~/.shrinkwrap/package/cca-3world/lkvm (kvmtool able to launch realms)
- ~/.shrinkwrap/package/cca-3world/kvm-unit-tests.tgz (built kvm-unit-tests)

Once the FVP is booted to a shell, you can do something like this to launch a
Linux guest in a realm:

  lkvm run --realm --disable-sve -c 1 -m 256 -k Image

[1] https://shrinkwrap.docs.arm.com
[2] https://gitlab.arm.com/tooling/shrinkwrap

