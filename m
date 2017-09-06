From: gengdongjiu <gengdongjiu@huawei.com>
Subject: re: [PATCH] arm64: KVM: VHE: save and restore some PSTATE bits
Date: Wed, 6 Sep 2017 15:08:43 +0000
Message-ID: <etPan.59b00f79.2fe72a3.4a29@localhost>
References: <0184EA26B2509940AA629AE1405DD7F2015EA4DE@DGGEMA503-MBX.china.huawei.com>,
 <79163d5d-90cf-9a94-457e-80cfffc0415f@arm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2794580552830239121=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DA9C49C29
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Sep 2017 11:07:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4p8Vzq1cfPLB for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Sep 2017 11:07:11 -0400 (EDT)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4175C40CE9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Sep 2017 11:07:09 -0400 (EDT)
In-Reply-To: <79163d5d-90cf-9a94-457e-80cfffc0415f@arm.com>
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
To: "vladimir.murzin" <vladimir.murzin@arm.com>, "marc.zyngier" <marc.zyngier@arm.com>, "christoffer.dall" <christoffer.dall@linaro.org>, pbonzini <pbonzini@redhat.com>, rkrcmar <rkrcmar@redhat.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "suzuki.poulose" <suzuki.poulose@arm.com>, "mark.rutland" <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
Cc: Huangshaoyu <huangshaoyu@huawei.com>, "Zhanghaibin (Euler)" <zhanghaibin7@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

--===============2794580552830239121==
Content-Language: zh-CN
Content-Type: multipart/alternative;
	boundary="_000_etPan59b00f792fe72a34a29localhost_"

--_000_etPan59b00f792fe72a34a29localhost_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

SXQgaXMgc2ltaWxhciB3aXRoIHRoZSBQQU6jrHdoZW4gdGhlIGd1ZXN0IHRyYXBzIHRvIGVsMqOs
aXQgd2lsbCByZXNldCB0aGUgcHN0YXRlLlBBTjxodHRwOi8vcHN0YXRlLlBBTj4gdG8gMCwgYW5k
IGNvbnRpbnVlIHJ1bqGjSW4gZmFjdCB0aGUgaG9zdCBwc3RhdGUuVUFPPGh0dHA6Ly9wc3RhdGUu
VUFPPiBjYW4gYmUgMSwgYnV0IGd1ZXN0IGNoYW5nZSBpdCB0byAwIHdoZW4gdHJhcCB0byBFTDKh
o3NvIGFmdGVyIHN3aWNoIHRvIGhvc3SjrG5lZWQgdG8gY2hlY2sgd2hldGhlciBzZXQgcHN0YXRl
LlVBTzxodHRwOi8vcHN0YXRlLlVBTz4gYWdhaW6how0Kt6K8/sjLo7pWbGFkaW1pciBNdXJ6aW4N
CsrVvP7Iy6O6uaK2q77DLG1hcmMuenluZ2llcixjaHJpc3RvZmZlci5kYWxsQGxpbmFyby5vcmcs
cGJvbnppbmlAcmVkaGF0LmNvbSxya3JjbWFyQHJlZGhhdC5jb20sbGludXgtYXJtLWtlcm5lbEBs
aXN0cy5pbmZyYWRlYWQub3JnLGt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUsa3ZtQHZnZXIu
a2VybmVsLm9yZyxsaW51eC1rZXJuZWwsc3V6dWtpLnBvdWxvc2VAYXJtLmNvbSxtYXJrLnJ1dGxh
bmRAYXJtLmNvbSxDYXRhbGluIE1hcmluYXMNCrOty82jukphbWVzIE1vcnNlLNXFuqOx8yy7xsnY
0+4NCsqxvOSjujIwMTctMDktMDYgMjI6NDE6MDkNCtb3zOI6UmU6IFtQQVRDSF0gYXJtNjQ6IEtW
TTogVkhFOiBzYXZlIGFuZCByZXN0b3JlIHNvbWUgUFNUQVRFIGJpdHMNCg0KT24gMDYvMDkvMTcg
MTU6MTAsIGdlbmdkb25naml1IHdyb3RlOg0KPiBIaSwgVmxhZGltaXINCj4NCj4+Pj4gRG8geW91
IHNlZSBlZmZlY3Qgb2YgIlBBTiBpcyB1bmV4cGVjdGVkbHkgZW5hYmxlZCI/DQo+Pj4gSW4gZmFj
dCBJIGRpZCBub3QgZW5jb3VudGVyIHRoaXMgY2FzZSwgYnV0IEkgdGhpbmsgaXQgY2FuIGV4aXN0
Lg0KPj4+IEkgdGhpbmsgaWYgaG9zdCBPUyBkeW5hbWljYWxseSBkaXNhYmxlIFBBTiwgaXQgd2Fu
dHMgdGhlIGhvc3Qga2VybmVsIGFjY2VzcyB0aGUgdXNlciBzcGFjZSBhZGRyZXNzIHNwYWNlIG5v
dCB0aHJvdWdoIGNvcHlfdG8vZnJvbV91c2VyDQo+PiBBUEkuDQo+Pj4gTm93IGlmIGl0IGlzIHVu
ZXhwZWN0ZWRseSBlbmFibGVkLCB3aGVuIGhvc3Qga2VybmVsIHN0aWxsIGFjY2Vzc2VzIHRoZSB1
c2VyIHNwYWNlIGFkZHJlc3MsICBpdCB3aWxsIGhhcHBlbiBNTVUgZmF1bHQgZXhjZXB0aW9uLg0K
Pj4NCj4+IEFuZCB0aGlzIGlzIGV4cGVjdGVkISBUaGUgb25seSBhbGxvd2VkIGNoYW5uZWwgZm9y
IGtlcm5lbCA8LT4gdXNlciBpcyB1YWNjZXNzIEFQSS4NCj4+DQo+PiBJIGd1ZXNzIHRoYXQgeW91
IGhhdmUgdGVzdCAoYW5kIHRoYXQgZ3JlYXQhKSB3aGljaCB2aW9sYXRlcyB0aGF0IHJ1bGUgKGZv
ciB0ZXN0aW5nIHB1cnBvc2UsIHdoeSBub3Q/KSBhbmQgbm93IHlvdSBhcmUgdHJ5aW5nIHRvIGZp
dCBrZXJuZWwgaW50bw0KPj4gaXQuLi4NCj4NCj4NCj4gSWYgeW91IHRoaW5rIHRoYXQgbWFrZXMg
c2Vuc2UgZm9yIGl0LCB3ZSBkbyBub3QgY29uc2lkZXIgdGhlIHBhc3RlLlBBTiBpbiB0aGUgd29y
bGQtc3dpdGNoLg0KPiBGb3IgdGhlIHBzdGF0ZS5VQU8gaXNzdWUsIGRvIHlvdSBhZ3JlZSBteSBm
aXhpbmcgb3IgeW91IGhhdmUgb3RoZXIgc3VnZ2VzdGlvbj8gIEFsc28gdG8gb3RoZXIgcmV2aWV3
ZXIuIFRoYW5rcy4NCg0KSXQgd291bGQgaGVscCBpZiB5b3UgZ2l2ZSBwcmVjaXNlIGRlc2NyaXB0
aW9uIG9uICJwc3RhdGUuVUFPIGlzc3VlIi4NCg0KVGhhbmtzDQpWbGFkaW1pcg0KDQo+DQo+IGRp
ZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9oeXAvc3lzcmVnLXNyLmMgYi9hcmNoL2FybTY0L2t2
bS9oeXAvc3lzcmVnLXNyLmMNCj4gaW5kZXggOTM0MTM3Ni4uYzNkZDc2MSAxMDA2NDQNCj4gLS0t
IGEvYXJjaC9hcm02NC9rdm0vaHlwL3N5c3JlZy1zci5jDQo+ICsrKyBiL2FyY2gvYXJtNjQva3Zt
L2h5cC9zeXNyZWctc3IuYw0KPiBAQCAtMjEsNiArMjEsOCBAQA0KPiAgI2luY2x1ZGUgPGFzbS9r
dm1fYXNtLmg+DQo+ICAjaW5jbHVkZSA8YXNtL2t2bV9oeXAuaD4NCj4NCj4gKyNpbmNsdWRlIDxh
c20vZXhlYy5oPg0KPg0KPiAgLyogWWVzLCB0aGlzIGRvZXMgbm90aGluZywgb24gcHVycG9zZSAq
Lw0KPiAgc3RhdGljIHZvaWQgX19oeXBfdGV4dCBfX3N5c3JlZ19kb19ub3RoaW5nKHN0cnVjdCBr
dm1fY3B1X2NvbnRleHQgKmN0eHQpIHsgfQ0KPg0KPiBAQCAtMTIxLDggKzEyMywxMyBAQCBzdGF0
aWMgdm9pZCBfX2h5cF90ZXh0IF9fc3lzcmVnX3Jlc3RvcmVfc3RhdGUoc3RydWN0IGt2bV9jcHVf
Y29udGV4dCAqY3R4dCkNCj4gICAgICAgICB3cml0ZV9zeXNyZWdfZWwxKGN0eHQtPmdwX3JlZ3Mu
c3BzcltLVk1fU1BTUl9FTDFdLHNwc3IpOw0KPiAgfQ0KPg0KPiArc3RhdGljIHZvaWQgX19oeXBf
dGV4dCBfX3N5c3JlZ19yZXN0b3JlX3N0YXRlX3ZoZShzdHJ1Y3Qga3ZtX2NwdV9jb250ZXh0ICpj
dHh0KQ0KPiArew0KPiArICAgIHVhb190aHJlYWRfc3dpdGNoKGN1cnJlbnQpOw0KPiArfQ0KPiAr
DQo+ICBzdGF0aWMgaHlwX2FsdGVybmF0ZV9zZWxlY3QoX19zeXNyZWdfY2FsbF9yZXN0b3JlX2hv
c3Rfc3RhdGUsDQo+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICBfX3N5c3JlZ19yZXN0b3Jl
X3N0YXRlLCBfX3N5c3JlZ19kb19ub3RoaW5nLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgX19zeXNyZWdfcmVzdG9yZV9zdGF0ZSwgX19zeXNyZWdfcmVzdG9yZV9zdGF0ZV92aGUsDQo+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBBUk02NF9IQVNfVklSVF9IT1NUX0VYVE4pOw0K
Pg0KPiAgdm9pZCBfX2h5cF90ZXh0IF9fc3lzcmVnX3Jlc3RvcmVfaG9zdF9zdGF0ZShzdHJ1Y3Qg
a3ZtX2NwdV9jb250ZXh0ICpjdHh0KQ0KPg0KPg0KPj4NCj4+IENoZWVycw0KPj4gVmxhZGltaXIN
Cj4+DQo+Pj4NCj4+Pg0KPj4+Pg0KPj4+PiBDaGVlcnMNCj4+Pj4gVmxhZGltaXINCj4+Pj4NCj4+
Pj4+DQo+Pj4+Pj4NCj4+Pj4+PiBDaGVlcnMNCj4+Pj4+PiBWbGFkaW1pcg0KPj4+Pj4+DQo+Pj4+
Pj4gLg0KPj4+Pj4+DQo+Pj4+Pg0KPj4+Pj4NCj4+Pj4NCj4+Pj4NCj4+Pj4gLg0KPj4+Pg0KPj4+
DQo+Pj4NCj4NCg0K

--_000_etPan59b00f792fe72a34a29localhost_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dgb2312">
<meta name=3D"Generator" content=3D"Microsoft Exchange Server">
<!-- converted from text --><style><!-- .EmailQuote { margin-left: 1pt; pad=
ding-left: 4pt; border-left: #800000 2px solid; } --></style>
</head>
<body>
<div>
<div>It is similar with the PAN=A3=ACwhen the guest traps to el2=A3=ACit wi=
ll reset the <a href=3D"http://pstate.PAN">
pstate.PAN</a> to 0, and continue run=A1=A3In fact the host <a href=3D"http=
://pstate.UAO">
pstate.UAO</a> can be 1, but guest change it to 0 when trap to EL2=A1=A3so =
after swich to host=A3=ACneed to check whether set
<a href=3D"http://pstate.UAO">pstate.UAO</a> again=A1=A3<br>
</div>
<div name=3D"x_AnyOffice-Background-Image" style=3D"border-top:1px solid #B=
5C4DF; font-size:14px; line-height:20px; padding:8px">
<div style=3D"word-break:break-all"><b>=B7=A2=BC=FE=C8=CB=A3=BA</b>Vladimir=
 Murzin</div>
<div style=3D"word-break:break-all"><b>=CA=D5=BC=FE=C8=CB=A3=BA</b>=B9=A2=
=B6=AB=BE=C3,marc.zyngier,christoffer.dall@linaro.org,pbonzini@redhat.com,r=
krcmar@redhat.com,linux-arm-kernel@lists.infradead.org,kvmarm@lists.cs.colu=
mbia.edu,kvm@vger.kernel.org,linux-kernel,suzuki.poulose@arm.com,mark.rutla=
nd@arm.com,Catalin
 Marinas</div>
<div style=3D"word-break:break-all"><b>=B3=AD=CB=CD=A3=BA</b>James Morse,=
=D5=C5=BA=A3=B1=F3,=BB=C6=C9=D8=D3=EE</div>
<div style=3D"word-break:break-all"><b>=CA=B1=BC=E4=A3=BA</b>2017-09-06 22:=
41:09</div>
<div style=3D"word-break:break-all"><b>=D6=F7=CC=E2:</b>Re: [PATCH] arm64: =
KVM: VHE: save and restore some PSTATE bits</div>
<div><br>
</div>
</div>
</div>
<font size=3D"2"><span style=3D"font-size:10pt;">
<div class=3D"PlainText">On 06/09/17 15:10, gengdongjiu wrote:<br>
&gt; Hi, Vladimir<br>
&gt; <br>
&gt;&gt;&gt;&gt; Do you see effect of &quot;PAN is unexpectedly enabled&quo=
t;?<br>
&gt;&gt;&gt; In fact I did not encounter this case, but I think it can exis=
t.<br>
&gt;&gt;&gt; I think if host OS dynamically disable PAN, it wants the host =
kernel access the user space address space not through copy_to/from_user<br=
>
&gt;&gt; API.<br>
&gt;&gt;&gt; Now if it is unexpectedly enabled, when host kernel still acce=
sses the user space address,&nbsp; it will happen MMU fault exception.<br>
&gt;&gt;<br>
&gt;&gt; And this is expected! The only allowed channel for kernel &lt;-&gt=
; user is uaccess API.<br>
&gt;&gt;<br>
&gt;&gt; I guess that you have test (and that great!) which violates that r=
ule (for testing purpose, why not?) and now you are trying to fit kernel in=
to<br>
&gt;&gt; it...<br>
&gt; <br>
&gt; <br>
&gt; If you think that makes sense for it, we do not consider the paste.PAN=
 in the world-switch.<br>
&gt; For the pstate.UAO issue, do you agree my fixing or you have other sug=
gestion?&nbsp; Also to other reviewer. Thanks.<br>
<br>
It would help if you give precise description on &quot;pstate.UAO issue&quo=
t;.<br>
<br>
Thanks<br>
Vladimir<br>
<br>
&gt; <br>
&gt; diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysre=
g-sr.c<br>
&gt; index 9341376..c3dd761 100644<br>
&gt; --- a/arch/arm64/kvm/hyp/sysreg-sr.c<br>
&gt; &#43;&#43;&#43; b/arch/arm64/kvm/hyp/sysreg-sr.c<br>
&gt; @@ -21,6 &#43;21,8 @@<br>
&gt;&nbsp; #include &lt;asm/kvm_asm.h&gt;<br>
&gt;&nbsp; #include &lt;asm/kvm_hyp.h&gt;<br>
&gt; <br>
&gt; &#43;#include &lt;asm/exec.h&gt;<br>
&gt; <br>
&gt;&nbsp; /* Yes, this does nothing, on purpose */<br>
&gt;&nbsp; static void __hyp_text __sysreg_do_nothing(struct kvm_cpu_contex=
t *ctxt) { }<br>
&gt; <br>
&gt; @@ -121,8 &#43;123,13 @@ static void __hyp_text __sysreg_restore_state=
(struct kvm_cpu_context *ctxt)<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; write_sysreg_el1(ctxt-=
&gt;gp_regs.spsr[KVM_SPSR_EL1],spsr);<br>
&gt;&nbsp; }<br>
&gt; <br>
&gt; &#43;static void __hyp_text __sysreg_restore_state_vhe(struct kvm_cpu_=
context *ctxt)<br>
&gt; &#43;{<br>
&gt; &#43;&nbsp;&nbsp;&nbsp; uao_thread_switch(current);<br>
&gt; &#43;}<br>
&gt; &#43;<br>
&gt;&nbsp; static hyp_alternate_select(__sysreg_call_restore_host_state,<br=
>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; __sysreg_restore_state, __sysreg_do_nothing,<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp; __sysreg_restore_state, __sysreg_restore_state_vhe,<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp; ARM64_HAS_VIRT_HOST_EXTN);<br>
&gt; <br>
&gt;&nbsp; void __hyp_text __sysreg_restore_host_state(struct kvm_cpu_conte=
xt *ctxt)<br>
&gt; <br>
&gt; <br>
&gt;&gt;<br>
&gt;&gt; Cheers<br>
&gt;&gt; Vladimir<br>
&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; Cheers<br>
&gt;&gt;&gt;&gt; Vladimir<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt;&gt; Cheers<br>
&gt;&gt;&gt;&gt;&gt;&gt; Vladimir<br>
&gt;&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt;&gt; .<br>
&gt;&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; .<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt; <br>
<br>
</div>
</span></font>
</body>
</html>

--_000_etPan59b00f792fe72a34a29localhost_--


--===============2794580552830239121==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============2794580552830239121==--
