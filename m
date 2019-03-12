From: "Tangnianyao (ICT)" <tangnianyao@huawei.com>
Subject: [PATCH] KVM: arm/arm64: Set ICH_HCR_EN in guest anyway when using
 gicv4
Date: Tue, 12 Mar 2019 12:22:15 +0000
Message-ID: <F348A9E21A573744858FF7E5D32E29D81FEFA462@DGGEMI529-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0701462110123298308=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 070E44A2E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Mar 2019 08:22:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LdcEBOCIKNSu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Mar 2019 08:22:28 -0400 (EDT)
Received: from huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 175E14A2E5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Mar 2019 08:22:28 -0400 (EDT)
Content-Language: zh-CN
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, "james.morse@arm.com" <james.morse@arm.com>, "julien.thierry@arm.com" <julien.thierry@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "alex.bennee@linaro.org" <alex.bennee@linaro.org>, "mark.rutland@arm.com" <mark.rutland@arm.com>, "andre.przywara@arm.com" <andre.przywara@arm.com>, "Tangnianyao (ICT)" <tangnianyao@huawei.com>, Zhangshaokun <zhangshaokun@hisilicon.com>, "keescook@chromium.org" <keescook@chromium.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

--===============0701462110123298308==
Content-Language: zh-CN
Content-Type: multipart/alternative;
	boundary="_000_F348A9E21A573744858FF7E5D32E29D81FEFA462DGGEMI529MBXchi_"

--_000_F348A9E21A573744858FF7E5D32E29D81FEFA462DGGEMI529MBXchi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

In gicv4, direct vlpi may be forward to PE without using LR or ap_list. If
ICH_HCR_EL2.En is 0 in guest, direct vlpi cannot be accepted by PE.
It will take long time for direct vlpi to be forwarded in some cases.
Direct vlpi has to wait for ICH_HCR_EL2.En=3D1 where some other interrupts
using LR need to be forwarded, because in kvm_vgic_flush_hwstate,
if ap_list is empty, it will return quickly not setting ICH_HCR_EL2.En.
To fix this, set ICH_HCR_EL2.En to 1 before returning to guest when
using GICv4.

Signed-off-by: Nianyao Tang <tangnianyao@huawei.com>
---
arch/arm64/include/asm/kvm_asm.h |  1 +
virt/kvm/arm/hyp/vgic-v3-sr.c    | 10 ++++++++++
virt/kvm/arm/vgic/vgic-v4.c      |  8 ++++++++
3 files changed, 19 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_=
asm.h
index f5b79e9..0581c4d 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -79,6 +79,7 @@
extern void __vgic_v3_init_lrs(void);
 extern u32 __kvm_get_mdcr_el2(void);
+extern void __vgic_v3_write_hcr(u32 vmcr);
 /* Home-grown __this_cpu_{ptr,read} variants that always work at HYP */
#define __hyp_this_cpu_ptr(sym)                                            =
            \
diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 264d92d..12027af 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -434,6 +434,16 @@ void __hyp_text __vgic_v3_write_vmcr(u32 vmcr)
       write_gicreg(vmcr, ICH_VMCR_EL2);
}
+u64 __hyp_text __vgic_v3_read_hcr(void)
+{
+       return read_gicreg(ICH_HCR_EL2);
+}
+
+void __hyp_text __vgic_v3_write_hcr(u32 vmcr)
+{
+       write_gicreg(vmcr, ICH_HCR_EL2);
+}
+
#ifdef CONFIG_ARM64
 static int __hyp_text __vgic_v3_bpr_min(void)
diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index 1ed5f22..515171a 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -208,6 +208,8 @@ int vgic_v4_sync_hwstate(struct kvm_vcpu *vcpu)
       if (!vgic_supports_direct_msis(vcpu->kvm))
                return 0;
+       __vgic_v3_write_hcr(vcpu->arch.vgic_cpu.vgic_v3.vgic_hcr & ~ICH_HCR=
_EN);
+
       return its_schedule_vpe(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe, false)=
;
}
@@ -220,6 +222,12 @@ int vgic_v4_flush_hwstate(struct kvm_vcpu *vcpu)
                return 0;
        /*
+       * Enable ICH_HCR_EL.En so that guest can accpet and handle direct
+       * vlpi.
+       */
+       __vgic_v3_write_hcr(vcpu->arch.vgic_cpu.vgic_v3.vgic_hcr);
+
+       /*
        * Before making the VPE resident, make sure the redistributor
        * corresponding to our current CPU expects us here. See the
        * doc in drivers/irqchip/irq-gic-v4.c to understand how this
--
1.9.1



--_000_F348A9E21A573744858FF7E5D32E29D81FEFA462DGGEMI529MBXchi_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
	font-size:10.5pt;
	font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#954F72;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri",sans-serif;}
/* Page Definitions */
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"ZH-CN" link=3D"#0563C1" vlink=3D"#954F72" style=3D"text-justi=
fy-trim:punctuation">
<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span lang=3D"EN-US">In gicv4, direct vlpi may be fo=
rward to PE without using LR or ap_list. If
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">ICH_HCR_EL2.En is 0 in guest, d=
irect vlpi cannot be accepted by PE.
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">It will take long time for dire=
ct vlpi to be forwarded in some cases.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">Direct vlpi has to wait for ICH=
_HCR_EL2.En=3D1 where some other interrupts<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">using LR need to be forwarded, =
because in kvm_vgic_flush_hwstate,
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">if ap_list is empty, it will re=
turn quickly not setting ICH_HCR_EL2.En.
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">To fix this, set ICH_HCR_EL2.En=
 to 1 before returning to guest when
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">using GICv4.<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">Signed-off-by: Nianyao Tang &lt=
;tangnianyao@huawei.com&gt;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">---<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">arch/arm64/include/asm/kvm_asm.=
h |&nbsp; 1 &#43;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">virt/kvm/arm/hyp/vgic-v3-sr.c&n=
bsp;&nbsp;&nbsp; | 10 &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;<o:=
p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">virt/kvm/arm/vgic/vgic-v4.c&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; 8 &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#4=
3;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">3 files changed, 19 insertions(=
&#43;)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">diff --git a/arch/arm64/include=
/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">index f5b79e9..0581c4d 100644<o=
:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">--- a/arch/arm64/include/asm/kv=
m_asm.h<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&#43;&#43;&#43; b/arch/arm64/in=
clude/asm/kvm_asm.h<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">@@ -79,6 &#43;79,7 @@<o:p></o:p=
></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">extern void __vgic_v3_init_lrs(=
void);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;extern u32 __kvm_get_mdcr=
_el2(void);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&#43;extern void __vgic_v3_writ=
e_hcr(u32 vmcr);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;/* Home-grown __this_cpu_=
{ptr,read} variants that always work at HYP */<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">#define __hyp_this_cpu_ptr(sym)=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">diff --git a/virt/kvm/arm/hyp/v=
gic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">index 264d92d..12027af 100644<o=
:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">--- a/virt/kvm/arm/hyp/vgic-v3-=
sr.c<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&#43;&#43;&#43; b/virt/kvm/arm/=
hyp/vgic-v3-sr.c<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">@@ -434,6 &#43;434,16 @@ void _=
_hyp_text __vgic_v3_write_vmcr(u32 vmcr)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; write_gicreg(vmcr, ICH_VMCR_EL2);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">}<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&#43;u64 __hyp_text __vgic_v3_r=
ead_hcr(void)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&#43;{<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&#43;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; return read_gicreg(ICH_HCR_EL2);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&#43;}<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&#43;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&#43;void __hyp_text __vgic_v3_=
write_hcr(u32 vmcr)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&#43;{<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&#43;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; write_gicreg(vmcr, ICH_HCR_EL2);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&#43;}<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&#43;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">#ifdef CONFIG_ARM64<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;static int __hyp_text __v=
gic_v3_bpr_min(void)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">diff --git a/virt/kvm/arm/vgic/=
vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">index 1ed5f22..515171a 100644<o=
:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">--- a/virt/kvm/arm/vgic/vgic-v4=
.c<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&#43;&#43;&#43; b/virt/kvm/arm/=
vgic/vgic-v4.c<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">@@ -208,6 &#43;208,8 @@ int vgi=
c_v4_sync_hwstate(struct kvm_vcpu *vcpu)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; if (!vgic_supports_direct_msis(vcpu-&gt;kvm))<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<o:p><=
/o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&#43;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; __vgic_v3_write_hcr(vcpu-&gt;arch.vgic_cpu.vgic_v3.vgic_hcr &amp=
; ~ICH_HCR_EN);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&#43;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; return its_schedule_vpe(&amp;vcpu-&gt;arch.vgic_cpu.vgic_v3.its_vpe, =
false);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">}<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">@@ -220,6 &#43;222,12 @@ int vg=
ic_v4_flush_hwstate(struct kvm_vcpu *vcpu)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<o:p><=
/o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; /*<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&#43;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; * Enable ICH_HCR_EL.En so that guest can accpet and handle direc=
t<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&#43;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; * vlpi.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&#43;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; */<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&#43;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; __vgic_v3_write_hcr(vcpu-&gt;arch.vgic_cpu.vgic_v3.vgic_hcr);<o:=
p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&#43;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&#43;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; /*<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; &nbsp;* Before making the VPE resident, make sure the redistributor<o=
:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; &nbsp;* corresponding to our current CPU expects us here. See the<o:p=
></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; &nbsp;* doc in drivers/irqchip/irq-gic-v4.c to understand how this<o:=
p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">-- <o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">1.9.1<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
</div>
</body>
</html>

--_000_F348A9E21A573744858FF7E5D32E29D81FEFA462DGGEMI529MBXchi_--

--===============0701462110123298308==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============0701462110123298308==--
