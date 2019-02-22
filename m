From: Stephen Hemminger <sthemmin@microsoft.com>
Subject: RE: [PATCH V3 1/10] X86/Hyper-V: Add parameter offset for
 hyperv_fill_flush_guest_mapping_list()
Date: Fri, 22 Feb 2019 17:08:41 +0000
Message-ID: <SN6PR2101MB0912C24CD03D22248C868196CC7F0@SN6PR2101MB0912.namprd21.prod.outlook.com>
References: <20190222150637.2337-1-Tianyu.Lan@microsoft.com>
 <20190222150637.2337-2-Tianyu.Lan@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190222150637.2337-2-Tianyu.Lan@microsoft.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "lantianyu1986@gmail.com" <lantianyu1986@gmail.com>
Cc: Tianyu Lan <Tianyu.Lan@microsoft.com>, "christoffer.dall@arm.com" <christoffer.dall@arm.com>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "jhogan@kernel.org" <jhogan@kernel.org>, "ralf@linux-mips.org" <ralf@linux-mips.org>, "paul.burton@mips.com" <paul.burton@mips.com>, "paulus@ozlabs.org" <paulus@ozlabs.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>, KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "sashal@kernel.org" <sashal@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>b
List-Id: kvmarm@lists.cs.columbia.edu

int hyperv_fill_flush_guest_mapping_list(
 		struct hv_guest_mapping_flush_list *flush,
-		u64 start_gfn, u64 pages)
+		int offset, u64 start_gfn, u64 pages)
 {
 	u64 cur =3D start_gfn;
 	u64 additional_pages;
-	int gpa_n =3D 0;
+	int gpa_n =3D offset;
=20
 	do {
 		/*

Do you mean to support negative offsets here? Maybe unsigned would be bette=
r?
