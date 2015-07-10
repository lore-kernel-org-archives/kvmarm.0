From: harry <13401187209@126.com>
Subject: ***SPAM*** KVM on ARM: How to add some functions into interrupt.S
 with C code?
Date: Fri, 10 Jul 2015 17:06:30 +0800 (CST)
Message-ID: <5675dfef.1beed.14e77374fec.Coremail.13401187209@126.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1735150762328217616=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E9CB584D5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 04:55:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eTxOsimtvIVm for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jul 2015 04:55:02 -0400 (EDT)
Received: from m15-12.126.com (m15-12.126.com [220.181.15.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79038584D4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 04:55:00 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

--===============1735150762328217616==
Content-Type: multipart/alternative;
	boundary="----=_Part_444473_1624145918.1436519190506"

------=_Part_444473_1624145918.1436519190506
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: base64

SSB3YW50IHRvIGFkZCBzb21lIGZ1bmN0aW9ucyBpbnRvIGludGVycnVwdC5TIHdpdGggQyBjb2Rl
IHRvIGRvIHNvbWUgb3BlcmF0aW9ucyBpbiBoeXAgbW9kZSB3aXRoIGEgaHlwY2FsbC4KCgpJIGhh
dmUgdHJpZWQgdG8gYWRkIC5nbG9iYWwgW2Z1bmN0aW9uIG5hbWVdIGFuZCB1c2UgYmwgW2Z1bmN0
aW9uIG5hbWVdLCBidXQgdGhlcmUgd2lsbCBiZSBhIHByZWZldGNoIGFib3J0LgoKClNvIEkgd2Fu
dCB0byBrbm93IGlmIHRoZSBDIGNvZGUgY2FuIGJlIGxpbmtlZCBpbnRvIGludGVycnVwdC5TIGFu
ZCBob3cgdG8gYWNoaWV2ZSB0aGlzLgoKClRoYW5rIHlvdSBmb3IgaGVscC4=
------=_Part_444473_1624145918.1436519190506
Content-Type: text/html; charset=GBK
Content-Transfer-Encoding: base64

PGRpdiBzdHlsZT0ibGluZS1oZWlnaHQ6MS43O2NvbG9yOiMwMDAwMDA7Zm9udC1zaXplOjE0cHg7
Zm9udC1mYW1pbHk6QXJpYWwiPjxkaXY+SSB3YW50IHRvIGFkZCBzb21lIGZ1bmN0aW9ucyBpbnRv
IGludGVycnVwdC5TIHdpdGggQyBjb2RlIHRvIGRvIHNvbWUgb3BlcmF0aW9ucyBpbiBoeXAgbW9k
ZSB3aXRoIGEgaHlwY2FsbC48L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2PkkgaGF2ZSB0cmllZCB0
byBhZGQgLmdsb2JhbCBbZnVuY3Rpb24gbmFtZV0gYW5kIHVzZSBibCBbZnVuY3Rpb24gbmFtZV0s
IGJ1dCB0aGVyZSB3aWxsIGJlIGEgcHJlZmV0Y2ggYWJvcnQuPC9kaXY+PGRpdj48YnI+PC9kaXY+
PGRpdj5TbyBJIHdhbnQgdG8ga25vdyBpZiB0aGUgQyBjb2RlIGNhbiBiZSBsaW5rZWQgaW50byBp
bnRlcnJ1cHQuUyBhbmQgaG93IHRvIGFjaGlldmUgdGhpcy48L2Rpdj48ZGl2Pjxicj48L2Rpdj48
ZGl2PlRoYW5rIHlvdSBmb3IgaGVscC48L2Rpdj48L2Rpdj48YnI+PGJyPjxzcGFuIHRpdGxlPSJu
ZXRlYXNlZm9vdGVyIj48c3BhbiBpZD0ibmV0ZWFzZV9tYWlsX2Zvb3RlciI+PGRpdiBpZD0ibmV0
ZWFzZV9tYWlsX2Zvb3RlciI+PGRpdiBzdHlsZT0iYm9yZGVyLXRvcDojQ0NDQ0NDIDFweCBzb2xp
ZDtwYWRkaW5nOjEwcHggNXB4O2ZvbnQtc2l6ZToxMnB4O2NvbG9yOiM3Nzc3Nzc7bGluZS1oZWln
aHQ6MjJweCI+wLTX1CA8YiBzdHlsZT0iY29sb3I6I0NDMzMwMCI+zfjS1zwvYj48YiBzdHlsZT0i
Y29sb3I6IzMzMzMzMyI+yta7+rrFwuvTys/kPC9iPiAtLSDT0MrWu/q+zdPQzfjS18rWu/q6xcLr
08rP5KOsPGEgaWQ9Im1vYmlsZV9zZXQiIHN5cz0iMSIgbG9nPTEgbG9naWQ9ImZyZWVfc21zXzIw
MTIwNTA0IiBocmVmPSJodHRwOi8vc2hvdWppLjE2My5jb20iIHRhcmdldD0iX2JsYW5rIiBzdHls
ZT0iY29sb3I6IzMzNjZGRjt0ZXh0LWRlY29yYXRpb246bm9uZSI+wcu94s/qx+kmZ3Q7PC9hPjwv
ZGl2PjwvZGl2Pgo8L3NwYW4+PC9zcGFuPg==
------=_Part_444473_1624145918.1436519190506--


--===============1735150762328217616==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1735150762328217616==--
