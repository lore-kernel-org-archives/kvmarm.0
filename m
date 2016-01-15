From: hiwu <hiwu@derytech.com.tw>
Subject: Re: ARM KVM guest virtual address to host virtual address Look up
Date: Fri, 15 Jan 2016 19:14:24 +0800
Message-ID: <q70d9pc1o02g0mosm9n96cvw.1452856464824@email.android.com>
References: <911dda08e570d71c948d7f9dad3e3e04.squirrel@mail.derytech.com.tw>
 <CAFEAcA-rOAGxVrEs5q--z5BFq2YR0ExK8cmQn2PX1s+cCo27hA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1272856498371830552=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 965D749A0A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 06:11:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ic8cAXoWGg1m for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2016 06:11:15 -0500 (EST)
Received: from msr5.hinet.net (msr5.hinet.net [168.95.4.105])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AC8949444
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 06:11:14 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

--===============1272856498371830552==
Content-Type: multipart/alternative; boundary="--_com.asus.email_552075371984660"

----_com.asus.email_552075371984660
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64

SGkgUGV0ZXI6CgpJIHdhbnQgdG8gdHJhcCBzb21lIGxkcixzdHIgaW5zdHJ1Y3Rpb24gaW4gZ3Vl
c3QgVk0gZm9yIGRlYnVnLiBUaGVyZWZvcmUsIEkgaGF2ZSB0byBlbXVsYXRlIGd1ZXN0IGxkcixz
dHIgaW4gaG9zdC4gV2l0aG91dCBndWVzdCBWQSB0byBob3N0IFZBLCBJIGNhbm5vdCBlbXVsYXRl
IGxkcixzdHIgaW5zdHJ1Y3Rpb24gaW4gaG9zdC4KClRoYW5rIHlvdQotSmFjawoKLS0tLS0tLS0g
5Y6f5aeL6YO15Lu2IC0tLS0tLS0tCuWvhOS7tuiAhe+8mlBldGVyIE1heWRlbGwgPHBldGVyLm1h
eWRlbGxAbGluYXJvLm9yZz4K5YKz6YCB5pel5pyf77yaRnJpLCAxNSBKYW4gMjAxNiAxODowMjoy
MyArMDgwMArmlLbku7bogIXvvJpoaXd1QGRlcnl0ZWNoLmNvbS50dwrlia/mnKzvvJprdm1hcm1A
bGlzdHMuY3MuY29sdW1iaWEuZWR1CuS4u+aXqDpSZTogQVJNIEtWTSBndWVzdCB2aXJ0dWFsIGFk
ZHJlc3MgdG8gaG9zdCB2aXJ0dWFsIGFkZHJlc3MgTG9vayB1cAoKPk9uIDE1IEphbnVhcnkgMjAx
NiBhdCAwOTozMywgIDxoaXd1QGRlcnl0ZWNoLmNvbS50dz4gd3JvdGU6Cj4+IEhvdyB0byBsb29r
dXAgaG9zdCB2aXJ0dWFsIGFkZHJlc3MgYnkgZ3Vlc3QgdmlydHVhbCBhZGRyZXNzID8KPj4gSXMg
dGhlcmUgYW55IGZ1bmN0aW9uIHRvIGRvIGd1ZXN0IHBhZ2UgdGFibGUgd2Fsaz8KPgo+VGhlcmUg
aXMgbm8gc2luZ2xlIGZ1bmN0aW9uIHRvIGRvIHRoaXMgKGRlcGVuZGluZyBvbiB3aGF0Cj5iaXQg
b2YgUUVNVSB0aGlzIGlzLCB3ZSBtaWdodCBlaXRoZXIgdHJ5IGEgVExCIGFjY2VzcyB0bwo+c2Vl
IGlmIHdlIGNhbiBnZXQgZ3Vlc3QtdmlydHVhbCB0byBob3N0LXZpcnR1YWwsIHdpdGggYQo+c2xv
dy1wYXRoIGZhbGxiYWNrIGZvciBUTEIgbWlzc2VzLCBvciB3ZSBtaWdodCBkbyBndWVzdAo+dmly
dHVhbCB0byBndWVzdCBwaHlzaWNhbCBhbmQgdGhlbiBsb29rIHVwIHdoZXRoZXIgdGhhdAo+aXMg
UkFNIG9yIGEgZGV2aWNlIGFuZCBiZWhhdmUgYWNjb3JkaW5nbHkpLiBXaGF0IGFyZSB5b3UKPmFj
dHVhbGx5IHRyeWluZyB0byBkbz8KPgo+dGhhbmtzCj4tLSBQTU0K
----_com.asus.email_552075371984660
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: base64

PHNwYW4gc3R5bGU9ImZvbnQtZmFtaWx5OiBBcmlhbDsgZm9udC1zaXplOjEycHQiPkhpIFBldGVy
Ojxicj48YnI+SSB3YW50IHRvIHRyYXAgc29tZSBsZHIsc3RyIGluc3RydWN0aW9uIGluIGd1ZXN0
IFZNIGZvciBkZWJ1Zy4gVGhlcmVmb3JlLCBJIGhhdmUgdG8gZW11bGF0ZSBndWVzdCBsZHIsc3Ry
IGluIGhvc3QuIFdpdGhvdXQgZ3Vlc3QgVkEgdG8gaG9zdCBWQSwgSSBjYW5ub3QgZW11bGF0ZSBs
ZHIsc3RyIGluc3RydWN0aW9uIGluIGhvc3QuPGJyPjxicj5UaGFuayB5b3U8YnI+LUphY2s8L3Nw
YW4+PHNwYW4gc3R5bGU9ImZvbnQtZmFtaWx5OiBBcmlhbDsiPjxicj48YnI+LS0tLS0tLS0g5Y6f
5aeL6YO15Lu2IC0tLS0tLS0tPGJyPuWvhOS7tuiAhe+8mlBldGVyIE1heWRlbGwgPHBldGVyLm1h
eWRlbGxAbGluYXJvLm9yZz48YnI+5YKz6YCB5pel5pyf77yaRnJpLCAxNSBKYW4gMjAxNiAxODow
MjoyMyArMDgwMDxicj7mlLbku7bogIXvvJpoaXd1QGRlcnl0ZWNoLmNvbS50dzxicj7lia/mnKzv
vJprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1PGJyPuS4u+aXqDpSZTogQVJNIEtWTSBndWVz
dCB2aXJ0dWFsIGFkZHJlc3MgdG8gaG9zdCB2aXJ0dWFsIGFkZHJlc3MgTG9vayB1cDxicj48YnI+
PC9zcGFuPk9uIDE1IEphbnVhcnkgMjAxNiBhdCAwOTozMywgIDxoaXd1QGRlcnl0ZWNoLmNvbS50
dz4gd3JvdGU6PGJyPj4gSG93IHRvIGxvb2t1cCBob3N0IHZpcnR1YWwgYWRkcmVzcyBieSBndWVz
dCB2aXJ0dWFsIGFkZHJlc3MgPzxicj4+IElzIHRoZXJlIGFueSBmdW5jdGlvbiB0byBkbyBndWVz
dCBwYWdlIHRhYmxlIHdhbGs/PGJyPjxicj5UaGVyZSBpcyBubyBzaW5nbGUgZnVuY3Rpb24gdG8g
ZG8gdGhpcyAoZGVwZW5kaW5nIG9uIHdoYXQ8YnI+Yml0IG9mIFFFTVUgdGhpcyBpcywgd2UgbWln
aHQgZWl0aGVyIHRyeSBhIFRMQiBhY2Nlc3MgdG88YnI+c2VlIGlmIHdlIGNhbiBnZXQgZ3Vlc3Qt
dmlydHVhbCB0byBob3N0LXZpcnR1YWwsIHdpdGggYTxicj5zbG93LXBhdGggZmFsbGJhY2sgZm9y
IFRMQiBtaXNzZXMsIG9yIHdlIG1pZ2h0IGRvIGd1ZXN0PGJyPnZpcnR1YWwgdG8gZ3Vlc3QgcGh5
c2ljYWwgYW5kIHRoZW4gbG9vayB1cCB3aGV0aGVyIHRoYXQ8YnI+aXMgUkFNIG9yIGEgZGV2aWNl
IGFuZCBiZWhhdmUgYWNjb3JkaW5nbHkpLiBXaGF0IGFyZSB5b3U8YnI+YWN0dWFsbHkgdHJ5aW5n
IHRvIGRvPzxicj48YnI+dGhhbmtzPGJyPi0tIFBNTTxicj4=
----_com.asus.email_552075371984660--


--===============1272856498371830552==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1272856498371830552==--
