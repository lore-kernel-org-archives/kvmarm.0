From: harry <tiancaixiaoyu90@126.com>
Subject: KVM/ARM:Read SP_usr and SP_svc in HYP mode
Date: Tue, 25 Aug 2015 12:40:28 +0800 (CST)
Message-ID: <4dca1652.6049.14f63284666.Coremail.tiancaixiaoyu90@126.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8345562649741037271=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24E3E41375
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Aug 2015 00:26:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RqybTzjKLNyG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Aug 2015 00:26:52 -0400 (EDT)
Received: from m15-1.126.com (m15-1.126.com [220.181.15.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A0CA41374
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Aug 2015 00:26:50 -0400 (EDT)
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

--===============8345562649741037271==
Content-Type: multipart/alternative;
	boundary="----=_Part_96853_1779189227.1440477628006"

------=_Part_96853_1779189227.1440477628006
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: base64

SGksCgpOb3cgSSB3YW50IHRvIGRvIG1vcmUgdGhpbmdzIGluIEhZUCBtb2RlLCBzbyBJIG5lZWQg
dG8gcmVhZCBTUF91c3IgYW5kIFNQX3N2YyB0byBnZXQgc29tZSBpbmZvcm1hdGlvbiBpbiBIWVAg
bW9kZS4gQnV0IEkgZG9uJ3Qga25vdyBob3cgdG8gYWNoaWV2ZSBpdC4gSXMgdGhlcmUgYW55IGFz
bSBjb21tYW5kIHRvIGFjaGlldmUgdGhpcz8gT3IgZG8gSSBuZWVkIHRvIHN3aXRjaCB0aGUgbW9k
ZSBtYW51YWxseSB0byByZWFkIGl0PwoKVGhhbmtzIGFuZCByZWdhcmRzLApIYXJyeQo=
------=_Part_96853_1779189227.1440477628006
Content-Type: text/html; charset=GBK
Content-Transfer-Encoding: base64

PGRpdiBzdHlsZT0ibGluZS1oZWlnaHQ6MS43O2NvbG9yOiMwMDAwMDA7Zm9udC1zaXplOjE0cHg7
Zm9udC1mYW1pbHk6QXJpYWwiPjxkaXY+SGksPGJyPjxicj5Ob3cgSSB3YW50IHRvIGRvIG1vcmUg
dGhpbmdzIGluIEhZUCBtb2RlLCBzbyBJIG5lZWQgdG8gcmVhZCBTUF91c3IgYW5kIFNQX3N2YyB0
byBnZXQgc29tZSBpbmZvcm1hdGlvbiBpbiBIWVAgbW9kZS4gQnV0IEkgZG9uJ3Qga25vdyBob3cg
dG8gYWNoaWV2ZSBpdC4gSXMgdGhlcmUgYW55IGFzbSBjb21tYW5kIHRvIGFjaGlldmUgdGhpcz8g
T3IgZG8gSSBuZWVkIHRvIHN3aXRjaCB0aGUgbW9kZSBtYW51YWxseSB0byByZWFkIGl0Pzxicj48
YnI+VGhhbmtzIGFuZCByZWdhcmRzLDxicj5IYXJyeTxicj48L2Rpdj48L2Rpdj48YnI+PGJyPjxz
cGFuIHRpdGxlPSJuZXRlYXNlZm9vdGVyIj48c3BhbiBpZD0ibmV0ZWFzZV9tYWlsX2Zvb3RlciI+
PGRpdiBpZD0ibmV0ZWFzZV9tYWlsX2Zvb3RlciI+PGRpdiBzdHlsZT0iYm9yZGVyLXRvcDojQ0ND
IDFweCBzb2xpZDtwYWRkaW5nOjEwcHggNXB4O2ZvbnQtc2l6ZToxMnB4O2NvbG9yOiM3Nzc7bGlu
ZS1oZWlnaHQ6MjJweCI+PGEgbG9nPTEgbG9naWQ9ImZvb3Rlcl9iZWF1dHlfMjAxNTA4MTYiIGhy
ZWY9Imh0dHA6Ly9yLm1haWwuMTYzLmNvbS9yLmpzcD91cmw9aHR0cCUzQSUyRiUyRjEuMTYzLmNv
bSUyRmhkJTJGb25lYWN0JTJGaGRmcmFtZS5kbyUzRmlkJTNEMjElMjZmcm9tJTNEZm9vdGVyX2Jl
YXV0eSZzaWduPTgxNzU5MzY4MSZfcl9pZ25vcmVfc3RhdElkPTdfMTNfNzlfNDgmX3JfaWdub3Jl
X3VpZD1udEAxNjMuY29tIiB0YXJnZXQ9Il9ibGFuayIgc3R5bGU9ImNvbG9yOiMzMzY2RkY7dGV4
dC1kZWNvcmF0aW9uOm5vbmUiPs/EyNWzqc/6sPG088XGw8DXsda70qox1Ko8L2E+PC9kaXY+PC9k
aXY+DQo8L3NwYW4+PC9zcGFuPg==
------=_Part_96853_1779189227.1440477628006--


--===============8345562649741037271==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8345562649741037271==--
